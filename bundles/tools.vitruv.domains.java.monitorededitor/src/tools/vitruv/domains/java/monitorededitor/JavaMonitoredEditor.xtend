package tools.vitruv.domains.java.monitorededitor

import java.util.ArrayList
import java.util.List
import java.util.Set
import org.apache.log4j.Logger
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.ui.IStartup
import org.eclipse.ui.PlatformUI
import tools.vitruv.domains.java.monitorededitor.astchangelistener.ASTChangeListener
import tools.vitruv.domains.java.monitorededitor.changeclassification.ChangeOperationListener
import tools.vitruv.domains.java.monitorededitor.changeclassification.events.ChangeClassifyingEvent
import tools.vitruv.framework.ui.monitorededitor.AbstractMonitoredEditor
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.userinteraction.UserInteractionFactory
import tools.vitruv.framework.userinteraction.UserInteractor
import tools.vitruv.framework.vsum.VirtualModel
import tools.vitruv.framework.vsum.modelsynchronization.ChangePropagator
import static com.google.common.base.Preconditions.checkState
import org.eclipse.xtend.lib.annotations.Delegate
import org.eclipse.core.resources.WorkspaceJob
import org.eclipse.xtend.lib.annotations.Accessors

/** 
 * Extends {@link AbstractMonitoredEditor} and implements {@link UserInteractor} by delegation to a dialog {@link UserInteractor}. 
 * The {@link MonitoredEditor} uses the {@link ASTChangeListener} to monitor changes in Java source code. The listener generates 
 * {@link ChangeClassifyingEvent}s which are transferred to the {@link ChangeResponder} who builds and returns {@link EMFModelChange} 
 * objects. These change objects are then used by the{@link ChangePropagator} to propagate changes to other with the code
 * affiliated EMF models.
 */
class JavaMonitoredEditor extends AbstractMonitoredEditor implements UserInteractor, ChangeOperationListener, ChangeSubmitter, IStartup {
	static val Logger log = Logger.getLogger(JavaMonitoredEditor)

	@Accessors(PUBLIC_GETTER)
	val Set<String> monitoredProjectNames
	@Accessors(PUBLIC_SETTER)
	boolean reportChanges
	@Delegate
	final UserInteractor userInteractor
	val ChangeResponder changeResponder
	val RecordingState recordingState
	val ASTChangeListener astListener
	val ()=>boolean shouldBeActive

	new(VirtualModel virtualModel, ()=>boolean shouldBeActive, String... monitoredProjectNames) {
		super(virtualModel)
		checkState(PlatformUI.getWorkbench() !== null,
			"Platform is not running but necessary for monitored Java editor")

		this.monitoredProjectNames = Set.of(monitoredProjectNames)
		this.userInteractor = UserInteractionFactory.instance.createDialogUserInteractor()
		this.automaticPropagationAfterMilliseconds = -1
		this.changeResponder = new ChangeResponder(this)
		this.reportChanges = true
		this.shouldBeActive = shouldBeActive
		this.recordingState = new RecordingState([submitPropagationJobIfNecessary])

		log.debug('''Start initializing monitored editor for projects: «monitoredProjectNames»''')
		astListener = new ASTChangeListener(this.monitoredProjectNames)
		astListener.addListener(this)
		log.trace('''Added AST change listener for projects: «monitoredProjectNames»''')
	}

	new(VirtualModel virtualModel, String... monitoredProjectNames) {
		this(virtualModel, [
			{
				return true
			}
		], monitoredProjectNames)
	}

	def void startMonitoring() {
		astListener.startListening
	}

	def void stopMonitoring() {
		astListener.shutdown()
	}

	private static class RecordingState {
		val List<VitruviusChange> changes = new ArrayList<VitruviusChange>()
		int lastChangeCount = 0
		val ()=>void submitPropagation

		new(()=>void submitPropagation) {
			this.submitPropagation = submitPropagation
		}

		def synchronized void reset() {
			changes.clear()
			lastChangeCount = 0
		}

		def synchronized void submitChange(VitruviusChange change) {
			changes.add(change)
			// If this is the first change, submit a propagation job
			if (changes.size() === 1) {
				submitPropagation.apply
			}
		}

		def synchronized boolean hasRecentlyBeenChanged() {
			return changes.size() !== lastChangeCount
		}

		def synchronized void touch() {
			lastChangeCount = changes.size()
		}

		def synchronized int getChangeCount() {
			return changes.size()
		}

		def synchronized Iterable<VitruviusChange> getChanges() {
			return changes
		}
	}

	def private synchronized void submitPropagationJobIfNecessary() {
		if (automaticPropagationAfterMilliseconds === -1) {
			return
		}
		log.trace('''Submitting propagation job for projects «monitoredProjectNames»''')
		val changePropagationJob = new WorkspaceJob("Change propagation job") {
			override runInWorkspace(IProgressMonitor monitor) {
				log.trace('''Checking for necessary change propagation in projects «monitoredProjectNames»''')
				if (!recordingState.hasRecentlyBeenChanged()) {
					propagateRecordedChanges()
				} else {
					recordingState.touch()
					submitPropagationJobIfNecessary()
				}
				return Status.OK_STATUS
			}
		}
		changePropagationJob.setPriority(Job.BUILD)
		// Defer change propagation while waiting for further changes to occur
		changePropagationJob.schedule(automaticPropagationAfterMilliseconds)
	}

	override void propagateRecordedChanges() {
		log.debug('''Propagating «recordingState.getChangeCount()» change(s) in projects «monitoredProjectNames»''')
		for (VitruviusChange change : recordingState.getChanges()) {
			try {
				this.virtualModel.propagateChange(change)
			} catch (Exception e) {
				log.error('''Some error occurred during propagating changes in projects «monitoredProjectNames»''')
				throw new IllegalStateException(e)
			}

		}
		recordingState.reset()
	}

	override synchronized void notifyEventClassified(ChangeClassifyingEvent event) {
		log.debug('''Monitored editor for projects «monitoredProjectNames» reacting to change «event»''')
		event.accept(changeResponder)
	}

	override synchronized void notifyEventOccured() {
		if (!shouldBeActive.apply) {
			stopMonitoring
		}
	}

	override synchronized void submitChange(VitruviusChange change) {
		if (!this.reportChanges) {
			log.
				trace('''Do not report change «change» because reporting is disabled for projects «monitoredProjectNames»''')
			return
		}
		log.trace('''Submit change in projects «monitoredProjectNames»''')
		recordingState.submitChange(change)
	}

	override void earlyStartup() {
	}

}
