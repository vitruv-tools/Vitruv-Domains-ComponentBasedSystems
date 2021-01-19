package tools.vitruv.domains.java.ui.monitorededitor

import java.util.ArrayList
import java.util.List
import java.util.Set
import org.apache.log4j.Logger
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.ui.IStartup
import org.eclipse.ui.PlatformUI
import tools.vitruv.domains.java.ui.monitorededitor.astchangelistener.ASTChangeListener
import tools.vitruv.domains.java.ui.monitorededitor.astchangelistener.ChangeOperationListener
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeClassifyingEvent
import tools.vitruv.framework.domains.ui.monitorededitor.AbstractMonitoredEditor
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.vsum.VirtualModel
import tools.vitruv.framework.vsum.modelsynchronization.ChangePropagator
import static com.google.common.base.Preconditions.checkState
import org.eclipse.core.resources.WorkspaceJob
import org.eclipse.xtend.lib.annotations.Accessors
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.conversion.ChangeClassifyingEventToVitruviusChangeConverter
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.conversion.ChangeClassifyingEventToVitruviusChangeConverterImpl
import java.util.function.Supplier

/** 
 * Extends {@link AbstractMonitoredEditor} and implements {@link UserInteractor} by delegation to a dialog {@link UserInteractor}. 
 * The {@link MonitoredEditor} uses the {@link ASTChangeListener} to monitor changes in Java source code. The listener generates 
 * {@link ChangeClassifyingEvent}s which are transferred to the {@link ChangeResponder} who builds and returns {@link EMFModelChange} 
 * objects. These change objects are then used by the{@link ChangePropagator} to propagate changes to other with the code
 * affiliated EMF models.
 */
class JavaMonitoredEditor extends AbstractMonitoredEditor implements ChangeOperationListener, IStartup {
	static val Logger log = Logger.getLogger(JavaMonitoredEditor)

	@Accessors(PUBLIC_GETTER)
	val Set<String> monitoredProjectNames
	@Accessors(PUBLIC_SETTER)
	volatile boolean reportChanges
	val ChangeClassifyingEventToVitruviusChangeConverter changeConverter
	val RecordingState recordingState
	val ASTChangeListener astListener
	val Supplier<Boolean> shouldBeActive

	new(VirtualModel virtualModel, Supplier<Boolean> shouldBeActive, String... monitoredProjectNames) {
		super(virtualModel)
		checkState(PlatformUI.getWorkbench() !== null,
			"Platform is not running but necessary for monitored Java editor")
		log.debug('''Start initializing monitored Java editor for projects «monitoredProjectNames»''')
		this.monitoredProjectNames = Set.of(monitoredProjectNames)
		this.changeConverter = new ChangeClassifyingEventToVitruviusChangeConverterImpl
		this.reportChanges = true
		this.shouldBeActive = shouldBeActive
		this.recordingState = new RecordingState([submitPropagationCheckJobIfNecessary])
		astListener = new ASTChangeListener(this.monitoredProjectNames)
		astListener.addListener(this)
		log.trace('''Finished initializing monitored Java editor for projects «monitoredProjectNames»''')
	}

	new(VirtualModel virtualModel, String... monitoredProjectNames) {
		this(virtualModel, [true], monitoredProjectNames)
	}

	def void startMonitoring() {
		astListener.startListening
	}

	def void stopMonitoring() {
		astListener.stopListening
	}

	def private void submitPropagationCheckJobIfNecessary() {
		if (automaticPropagationAfterMilliseconds == -1) {
			return
		}
		log.trace('''Submitting propagation job for projects «monitoredProjectNames»''')
		val changePropagationJob = new WorkspaceJob("Change propagation check job") {
			override runInWorkspace(IProgressMonitor monitor) {
				propagateRecordedChangesIfNecessary
				return Status.OK_STATUS
			}
		}
		changePropagationJob.setPriority(Job.SHORT)
		// Defer change propagation while waiting for further changes to occur
		changePropagationJob.schedule(automaticPropagationAfterMilliseconds)
	}

	private def synchronized void propagateRecordedChangesIfNecessary() {
		log.trace('''Checking for necessary change propagation in projects «monitoredProjectNames»''')
		if (!recordingState.hasRecentlyBeenChanged()) {
			submitChangePropagationJob
		} else {
			recordingState.touch()
			submitPropagationCheckJobIfNecessary
		}
	}

	override void propagateRecordedChanges() {
		log.debug('''Explicitly triggered change propagation for projects «monitoredProjectNames»''')
		submitChangePropagationJob
	}

	def private void submitChangePropagationJob() {
		log.trace('''Submitting change propagation job for projects «monitoredProjectNames»''')
		val changePropagationJob = new WorkspaceJob("Change propagation job") {
			override runInWorkspace(IProgressMonitor monitor) {
				internalPropagateRecordedChanges
				return Status.OK_STATUS
			}
		}
		changePropagationJob.setPriority(Job.BUILD)
		changePropagationJob.schedule()
	}

	private def synchronized void internalPropagateRecordedChanges() {
		log.debug('''Propagating «recordingState.changeCount» change(s) in projects «monitoredProjectNames»''')
		for (VitruviusChange change : recordingState.changes) {
			try {
				this.virtualModel.propagateChange(change)
			} catch (Exception e) {
				log.error('''Some error occurred during propagating changes in projects «monitoredProjectNames»''')
				throw new IllegalStateException(e)
			}
		}
		recordingState.reset()
	}

	override synchronized void notifyEventOccured() {
		if (!shouldBeActive.get) {
			stopMonitoring
		}
	}

	override synchronized void notifyEventClassified(ChangeClassifyingEvent event) {
		log.debug('''Monitored editor for projects «monitoredProjectNames» reacting to change «event»''')
		val convertedChange = changeConverter.convert(event)
		if (!convertedChange.empty) {
			if (!this.reportChanges) {
				log.
					trace('''Do not report change «convertedChange» because reporting is disabled for projects «monitoredProjectNames»''')
				return
			}
			log.trace('''Submit change in projects «monitoredProjectNames»''')
			recordingState.submitChange(convertedChange.get)
		}
	}

	override void earlyStartup() {
	}

	private static class RecordingState {
		val List<VitruviusChange> changes = new ArrayList<VitruviusChange>()
		int lastChangeCount = 0
		val ()=>void submitPropagation

		new(()=>void submitPropagation) {
			this.submitPropagation = submitPropagation
		}

		def void reset() {
			changes.clear()
			lastChangeCount = 0
		}

		def void submitChange(VitruviusChange change) {
			changes.add(change)
			// If this is the first change, submit a propagation job
			if (changes.size() === 1) {
				submitPropagation.apply
			}
		}

		def boolean hasRecentlyBeenChanged() {
			return changes.size() !== lastChangeCount
		}

		def void touch() {
			lastChangeCount = changes.size()
		}

		def int getChangeCount() {
			return changes.size()
		}

		def Iterable<VitruviusChange> getChanges() {
			return changes
		}
	}

}
