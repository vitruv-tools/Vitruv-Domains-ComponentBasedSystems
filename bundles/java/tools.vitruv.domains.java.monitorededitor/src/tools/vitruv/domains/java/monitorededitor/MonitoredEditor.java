package tools.vitruv.domains.java.monitorededitor;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.ui.IStartup;

import tools.vitruv.domains.java.monitorededitor.astchangelistener.ASTChangeListener;
import tools.vitruv.domains.java.monitorededitor.changeclassification.ChangeOperationListener;
import tools.vitruv.domains.java.monitorededitor.changeclassification.events.ChangeClassifyingEvent;
import tools.vitruv.domains.java.monitorededitor.refactoringlistener.RefactoringChangeListener;
import tools.vitruv.domains.java.monitorededitor.refactoringlistener.RefactoringStatusListener;
import tools.vitruv.framework.change.description.CompositeContainerChange;
import tools.vitruv.framework.change.description.PropagatedChange;
import tools.vitruv.framework.change.description.VitruviusChangeFactory;
import tools.vitruv.framework.uuid.UuidGeneratorAndResolver;
import tools.vitruv.framework.ui.monitorededitor.AbstractMonitoredEditor;
import tools.vitruv.framework.change.description.VitruviusChange;
import tools.vitruv.framework.userinteraction.UserInteractionFactory;
import tools.vitruv.framework.userinteraction.UserInteractor;
import tools.vitruv.framework.userinteraction.builder.ConfirmationInteractionBuilder;
import tools.vitruv.framework.userinteraction.builder.MultipleChoiceMultiSelectionInteractionBuilder;
import tools.vitruv.framework.userinteraction.builder.MultipleChoiceSingleSelectionInteractionBuilder;
import tools.vitruv.framework.userinteraction.builder.NotificationInteractionBuilder;
import tools.vitruv.framework.userinteraction.builder.TextInputInteractionBuilder;
import tools.vitruv.framework.util.datatypes.ModelInstance;
import tools.vitruv.framework.util.datatypes.VURI;
import tools.vitruv.framework.vsum.VirtualModel;
import tools.vitruv.framework.vsum.modelsynchronization.ChangePropagator;

/**
 * @author messinger
 *         <p>
 *         Extends {@link AbstractMonitoredEditor} and implements {@link UserInteractor} by
 *         delegation to a dialog {@link UserInteractor}. The {@link MonitoredEditor} uses the
 *         {@link ASTChangeListener} and the {@link RefactoringChangeListener} to monitor changes in
 *         Java source code. Both listeners generate {@link ChangeClassifyingEvent}s which are
 *         transferred to the {@link ChangeResponder} who builds and returns {@link EMFModelChange}
 *         objects. These change objects are then used by the {@link ChangePropagator} to
 *         propagate changes to other with the code affiliated EMF models.
 *
 */
public class MonitoredEditor extends AbstractMonitoredEditor
        implements UserInteractor, ChangeOperationListener, ChangeSubmitter, IStartup {

    private final Logger log = Logger.getLogger(MonitoredEditor.class);

    /**
     * @author messinger
     *
     *         Rudimentary time measurement for performance evaluation. This is a DTO class.
     */
    static class TimeMeasurement {
        long createASTchangeEvent, createEMFchange, total;

        TimeMeasurement(final long t0, final long t1) {
            final long now = System.nanoTime();
            this.total = now - t0;
            this.createASTchangeEvent = t1 - t0;
            this.createEMFchange = now - t1;
        }

        @Override
        public String toString() {
            // return "TimeMeasurement [createASTchangeEvent=" + this.createASTchangeEvent +
            // ", createEMFchange="
            // + this.createEMFchange + ", total=" + this.total + "]";
            return "TimeMeasurement:" + this.createASTchangeEvent + "," + this.createEMFchange + "," + this.total;
        }

    }

    private final ASTChangeListener astListener;
    private final RefactoringChangeListener refactoringListener;
    private final ChangeResponder changeResponder;
    private final RefactoringStatusListener refactoringStatusListener = new RefactoringStatusListener() {
        // switch off AST Listening while a refactoring is being performed

        @Override
        public void preExecute() {
            MonitoredEditor.this.log.info("Stop AST Listening");
            MonitoredEditor.this.stopASTListening();
            MonitoredEditor.this.startCollectInCompositeChange();
        }

        @Override
        public void postExecute() {
            MonitoredEditor.this.log.info("Start AST Listening");
            MonitoredEditor.this.startASTListening();
            MonitoredEditor.this.lastRefactoringTime = System.nanoTime();
        }

        @Override
        public void aboutPostExecute() {
            MonitoredEditor.this.stopCollectInCompositeChange();
        }
    };

    private final String[] monitoredProjectNames;
    private final UserInteractor userInteractor;
    private long lastRefactoringTime;
    protected boolean refactoringInProgress = false;
    private CompositeContainerChange changeStash = null;
    private boolean reportChanges;
    private static final String MY_MONITORED_PROJECT = "hadoop-hdfs";// "FooProject";

    // "MediaStore";

    public MonitoredEditor() {
        this(new VirtualModel() {
			@Override
			public List<PropagatedChange> propagateChange(VitruviusChange change) {
	            return null;
	        }
			@Override
			public List<PropagatedChange> propagateChangedState(Resource newState) {
				return null;
			}
			@Override
			public List<PropagatedChange> propagateChangedState(Resource newState, URI oldLocation) {
				return null;
			}
			@Override
			public ModelInstance getModelInstance(VURI modelVuri) {
				return null;
			}
			@Override
			public File getFolder() {
				return null;
			}
			@Override
			public void reverseChanges(List<PropagatedChange> changes) {
			}
			@Override
			public UuidGeneratorAndResolver getUuidGeneratorAndResolver() {
				return null;
			}
        }, MY_MONITORED_PROJECT);
        this.reportChanges = true;
    }

    protected void stopCollectInCompositeChange() {
        this.log.debug("Stop collecting Changes in CompositeChange stash and submit stash");
        this.triggerChange(null);
        this.refactoringInProgress = false;
    }

    protected void startCollectInCompositeChange() {
        this.log.debug("Start collecting Changes in CompositeChange stash");
        this.changeStash = VitruviusChangeFactory.getInstance().createCompositeContainerChange();
        this.refactoringInProgress = true;
    }

    public MonitoredEditor(final VirtualModel virtualModel,
            final String... monitoredProjectNames) {
        super(virtualModel);

        this.configureLogger();

        this.monitoredProjectNames = monitoredProjectNames;
        this.astListener = new ASTChangeListener(this.monitoredProjectNames);
        this.astListener.addListener(this);
        this.refactoringListener = RefactoringChangeListener.getInstance(this.monitoredProjectNames);
        this.refactoringListener.addListener(this.refactoringStatusListener);
        this.refactoringListener.addListener(this);
        // dummy CorrespondenceModel
        // this.buildCorrespondenceModel();
        this.changeResponder = new ChangeResponder(this);
        this.userInteractor = UserInteractionFactory.instance.createDialogUserInteractor();
        this.reportChanges = true;
        // this.addDummyCorrespondencesForAllInterfaceMethods();
    }

    protected void revokeRegistrations() {
        this.astListener.removeListener(this);
        this.astListener.revokeRegistrations();
        this.refactoringListener.removeListener(this);
        this.refactoringListener.removeListener(this.refactoringStatusListener);
        RefactoringChangeListener.destroyInstance();
    }

    private void configureLogger() {
        try {
        	// TODO Remove this!? Or make is configurable, as it is only needed for performance measurements
            final TimeFileLogAppender appender = TimeFileLogAppender.createInstanceFor(MY_MONITORED_PROJECT,
                    // "C:/Users/messinger/DominikMessinger/EvaluationData/hadoop-hdfs_monitor-overhead-measurements/time_measurements");
                    "EvaluationData/hadoop-hdfs_monitor-overhead-measurements/time_measurements");
            this.log.addAppender(appender);
        } catch (final IOException e) {
            e.printStackTrace();
        }
    }

    public String[] getMonitoredProjectNames() {
        return this.monitoredProjectNames;
    }

    @Override
    public void update(final ChangeClassifyingEvent event) {
        this.log.info("React to " + event.toString());
        event.accept(this.changeResponder);
    }

    @Override
    public void submitChange(final VitruviusChange change) {

        // basic time measurement for thesis evaluation
        final long million = 1000 * 1000;

        if (this.astListener.lastChangeTime >= 0) {
            final TimeMeasurement time = new TimeMeasurement(this.astListener.lastChangeTime,
                    ChangeResponder.lastCallTime);
            this.log.debug("MonitoredEditor required " + time.total / million
                    + " msec for the last *AST* change observation.");
            this.log.info(time.toString());
        } else if (this.lastRefactoringTime >= 0) {
            final TimeMeasurement time = new TimeMeasurement(this.lastRefactoringTime, ChangeResponder.lastCallTime);
            this.log.debug("MonitoredEditor required " + time.total / million
                    + " msec for the last *refactoring* change observation.");
            this.log.info(time.toString());
        }
        this.astListener.lastChangeTime = -1;
        this.lastRefactoringTime = -1;

        this.synchronizeChangeOrAddToCompositeChange(change);
    }

    private void synchronizeChangeOrAddToCompositeChange(final VitruviusChange change) {
        if (this.changeStash == null) {
            this.triggerChange(change);
        }
    }

    @Override
    public void earlyStartup() {
        // TODO Auto-generated method stub
        System.err.println("MonitoredEditor plugin - earlyStartup");
    }

    public void startASTListening() {
        this.astListener.startListening();
    }

    public void stopASTListening() {
        this.astListener.stopListening();
    }

    protected void triggerChange(final VitruviusChange change) {
        if (!this.reportChanges) {
            this.log.trace("Do not report change : " + change + " because report changes is set to false.");
            return;
        }
        final Job triggerChangeJob = new Job("Code monitor trigger job") {

            @Override
            protected IStatus run(final IProgressMonitor monitor) {
            	// Wait some time to ensure that all file system accesses (package/file creation etc)
            	// have been finalized, as they are executed concurrently
            	// TODO This is rather ugly. Can be wait for some kind of generic event here? Probably not...
            	try {
            		Thread.sleep(200);
            	} catch (InterruptedException e) {
            		// Do nothing
            	}
                if (null != change) {
                    MonitoredEditor.this.virtualModel.propagateChange(change);
                } else {
                    MonitoredEditor.this.virtualModel.propagateChange(MonitoredEditor.this.changeStash);
                }
                return Status.OK_STATUS;
            }
        };
        triggerChangeJob.setPriority(Job.SHORT);
        triggerChangeJob.schedule();

    }

    public void setReportChanges(final boolean reportChanges) {
        this.reportChanges = reportChanges;
    }

	@Override
	public NotificationInteractionBuilder getNotificationDialogBuilder() {
		return userInteractor.getNotificationDialogBuilder();
	}

	@Override
	public ConfirmationInteractionBuilder getConfirmationDialogBuilder() {
		return userInteractor.getConfirmationDialogBuilder();
	}

	@Override
	public TextInputInteractionBuilder getTextInputDialogBuilder() {
		return userInteractor.getTextInputDialogBuilder();
	}

	@Override
	public MultipleChoiceSingleSelectionInteractionBuilder getSingleSelectionDialogBuilder() {
		return userInteractor.getSingleSelectionDialogBuilder();
	}

	@Override
	public MultipleChoiceMultiSelectionInteractionBuilder getMultiSelectionDialogBuilder() {
		return userInteractor.getMultiSelectionDialogBuilder();
	}

}
