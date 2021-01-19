package tools.vitruv.domains.java.ui.monitorededitor.methodchange.events;

import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeClassifyingEventExtension;
import tools.vitruv.domains.java.ui.monitorededitor.jamopputil.CompilationUnitAdapter;

/**
 * Base interface for change events, which are extensions for the
 * MonitoredEditor and require an original and changed state.
 */
public interface OriginalAndOldChangeClassifiyingEventExtension extends
		ChangeClassifyingEventExtension {

	/**
	 * 
	 * @return The compilation unit for the original state.
	 */
	CompilationUnitAdapter getOriginalCompilationUnit();

	/**
	 * @return The compilation unit for the changed state.
	 */
	CompilationUnitAdapter getChangedCompilationUnit();

}
