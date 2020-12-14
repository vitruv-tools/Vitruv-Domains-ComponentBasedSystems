package tools.vitruv.domains.java.monitorededitor;

import java.util.Arrays;
import java.util.function.Supplier;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.ui.IStartup;
import org.eclipse.ui.PlatformUI;

import tools.vitruv.domains.java.monitorededitor.astchangelistener.ASTChangeListener;
import tools.vitruv.domains.java.monitorededitor.changeclassification.ChangeOperationListener;
import tools.vitruv.domains.java.monitorededitor.changeclassification.events.ChangeClassifyingEvent;
import tools.vitruv.domains.java.monitorededitor.refactoringlistener.RefactoringChangeListener;
import tools.vitruv.domains.java.monitorededitor.refactoringlistener.RefactoringStatusListener;
import tools.vitruv.framework.change.description.CompositeContainerChange;
import tools.vitruv.framework.change.description.VitruviusChangeFactory;
import tools.vitruv.framework.ui.monitorededitor.AbstractMonitoredEditor;
import tools.vitruv.framework.change.description.VitruviusChange;
import tools.vitruv.framework.userinteraction.UserInteractionFactory;
import tools.vitruv.framework.userinteraction.UserInteractor;
import tools.vitruv.framework.userinteraction.builder.ConfirmationInteractionBuilder;
import tools.vitruv.framework.userinteraction.builder.MultipleChoiceMultiSelectionInteractionBuilder;
import tools.vitruv.framework.userinteraction.builder.MultipleChoiceSingleSelectionInteractionBuilder;
import tools.vitruv.framework.userinteraction.builder.NotificationInteractionBuilder;
import tools.vitruv.framework.userinteraction.builder.TextInputInteractionBuilder;
import tools.vitruv.framework.vsum.VirtualModel;
import tools.vitruv.framework.vsum.modelsynchronization.ChangePropagator;

/**
 * @author messinger
 *         <p>
 *         Extends {@link AbstractMonitoredEditor} and implements
 *         {@link UserInteractor} by delegation to a dialog
 *         {@link UserInteractor}. The {@link MonitoredEditor} uses the
 *         {@link ASTChangeListener} and the {@link RefactoringChangeListener}
 *         to monitor changes in Java source code. Both listeners generate
 *         {@link ChangeClassifyingEvent}s which are transferred to the
 *         {@link ChangeResponder} who builds and returns {@link EMFModelChange}
 *         objects. These change objects are then used by the
 *         {@link ChangePropagator} to propagate changes to other with the code
 *         affiliated EMF models.
 *
 */
public class MonitoredEditor extends AbstractMonitoredEditor
		implements UserInteractor, ChangeOperationListener, ChangeSubmitter, IStartup {

	private final Logger log = Logger.getLogger(MonitoredEditor.class);

	/**
	 * @author messinger
	 *
	 *         Rudimentary time measurement for performance evaluation. This is a
	 *         DTO class.
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

	private ASTChangeListener astListener;
	private RefactoringChangeListener refactoringListener;
	private ChangeResponder changeResponder;
	private RefactoringStatusListener refactoringStatusListener = new RefactoringStatusListener() {
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
	private final Supplier<Boolean> shouldBeActive;

	protected void stopCollectInCompositeChange() {
		this.log.trace("Stop collecting Changes in CompositeChange stash and submit stash");
		this.triggerChange(null);
		this.refactoringInProgress = false;
	}

	protected void startCollectInCompositeChange() {
		this.log.trace("Start collecting Changes in CompositeChange stash");
		this.changeStash = VitruviusChangeFactory.getInstance().createCompositeContainerChange();
		this.refactoringInProgress = true;
	}

	public MonitoredEditor(final VirtualModel virtualModel, Supplier<Boolean> shouldBeActive,
			final String... monitoredProjectNames) {
		super(virtualModel);
		this.monitoredProjectNames = monitoredProjectNames;
		this.userInteractor = UserInteractionFactory.instance.createDialogUserInteractor();
		this.shouldBeActive = shouldBeActive;
	}

	public MonitoredEditor(final VirtualModel virtualModel, final String... monitoredProjectNames) {
		this(virtualModel, () -> {
			return true;
		}, monitoredProjectNames);
	}

	public void startMonitoring() {
		if (PlatformUI.getWorkbench() == null) {
			log.error("Platform is not running but necessary for monitored Java editor");
			throw new IllegalStateException("Platform is not running but necessary for monitored Java editor");
		}
		log.debug("Start initializing monitored editor for projects: " + Arrays.toString(monitoredProjectNames));
		this.astListener = new ASTChangeListener(this::isAlive, this.monitoredProjectNames);
		this.astListener.addListener(this);
		log.trace("Added AST change listener for projects: " + Arrays.toString(monitoredProjectNames));
		this.refactoringListener = RefactoringChangeListener.getInstance(this.monitoredProjectNames);
		this.refactoringListener.addListener(this.refactoringStatusListener);
		this.refactoringListener.addListener(this);
		log.trace("Added refactorig lister for projects: " + Arrays.toString(monitoredProjectNames));
		this.changeResponder = new ChangeResponder(this);
		this.reportChanges = true;
		log.trace("Finished initializing monitored editor for projects: " + Arrays.toString(monitoredProjectNames));
	}

	protected void revokeRegistrations() {
		this.astListener.removeListener(this);
		this.astListener.revokeRegistrations();
		this.refactoringListener.removeListener(this);
		this.refactoringListener.removeListener(this.refactoringStatusListener);
		RefactoringChangeListener.destroyInstance();
	}

	private boolean isAlive() {
		if (shouldBeActive.get()) {
			return true;
		} else {
			stopASTListening();
			revokeRegistrations();
			return false;
		}

	}

	public String[] getMonitoredProjectNames() {
		return this.monitoredProjectNames;
	}

	@Override
	public void update(final ChangeClassifyingEvent event) {
		this.log.debug("Monitored editor for projects " + Arrays.toString(getMonitoredProjectNames())
				+ " reacting to change " + event.toString());
		event.accept(this.changeResponder);
	}

	@Override
	public void submitChange(final VitruviusChange change) {

		// basic time measurement for thesis evaluation
		final long million = 1000 * 1000;

		if (this.astListener.lastChangeTime >= 0) {
			final TimeMeasurement time = new TimeMeasurement(this.astListener.lastChangeTime,
					ChangeResponder.lastCallTime);
			this.log.trace("MonitoredEditor required " + time.total / million
					+ " msec for the last *AST* change observation.");
		} else if (this.lastRefactoringTime >= 0) {
			final TimeMeasurement time = new TimeMeasurement(this.lastRefactoringTime, ChangeResponder.lastCallTime);
			this.log.trace("MonitoredEditor required " + time.total / million
					+ " msec for the last *refactoring* change observation.");
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
		log.debug("Monitored editor starts AST listening for projeects: " + Arrays.toString(monitoredProjectNames));
		this.astListener.startListening();
	}

	public void stopASTListening() {
		this.astListener.stopListening();
		log.debug("Monitored editor stopped AST listening for projeects: " + Arrays.toString(monitoredProjectNames));
	}

	protected void triggerChange(final VitruviusChange change) {
		if (!this.reportChanges) {
			this.log.trace("Do not report change : " + change + " because report changes is set to false.");
			return;
		}
		final Job triggerChangeJob = new Job("Code monitor trigger job") {

			@Override
			protected IStatus run(final IProgressMonitor monitor) {
				// Wait some time to ensure that all file system accesses (package/file creation
				// etc)
				// have been finalized, as they are executed concurrently
				// TODO This is rather ugly. Can be wait for some kind of generic event here?
				// Probably not...
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
