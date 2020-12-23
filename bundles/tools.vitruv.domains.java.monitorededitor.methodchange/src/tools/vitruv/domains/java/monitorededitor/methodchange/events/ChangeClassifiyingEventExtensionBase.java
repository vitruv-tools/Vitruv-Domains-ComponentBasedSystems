package tools.vitruv.domains.java.monitorededitor.methodchange.events;

import org.eclipse.jdt.core.dom.ASTNode;

import tools.vitruv.domains.java.monitorededitor.changeclassification.events.ChangeClassifyingEvent;
import tools.vitruv.domains.java.monitorededitor.changeclassification.events.ChangeClassifyingEventExtension;
import tools.vitruv.domains.java.monitorededitor.changeclassification.events.ChangeEventVisitor;
import tools.vitruv.domains.java.monitorededitor.jamopputil.CompilationUnitAdapter;
import tools.vitruv.domains.java.monitorededitor.methodchange.utils.JamoppUtilities;

/**
 * Base class for all change classifying event extensions, which need an old and
 * a new state.
 * @param <T> The type of the changed element.
 */
public abstract class ChangeClassifiyingEventExtensionBase <T extends ASTNode> extends
		ChangeClassifyingEvent implements
		OriginalAndOldChangeClassifiyingEventExtension {

	private final CompilationUnitAdapter originalCU;
	private final CompilationUnitAdapter changedCU;
	private final T originalElement;
	private final T changedElement;

	/**
	 * Constructor.
	 * 
	 * @param originalASTNode
	 *            An AST node from the old state.
	 * @param changedASTNode
	 *            An AST node from the new state.
	 */
	protected ChangeClassifiyingEventExtensionBase(T originalASTNode,
			T changedASTNode) {
		originalCU = JamoppUtilities
				.getUnsavedCompilationUnitAdapter(originalASTNode);
		changedCU = JamoppUtilities
				.getUnsavedCompilationUnitAdapter(changedASTNode);
		originalElement = originalASTNode;
		changedElement = changedASTNode;
	}

	@Override
	public void accept(ChangeEventVisitor visitor) {
		visitor.visit((ChangeClassifyingEventExtension) this);
	}

	@Override
	public CompilationUnitAdapter getChangedCompilationUnit() {
		return changedCU;
	}

	@Override
	public CompilationUnitAdapter getOriginalCompilationUnit() {
		return originalCU;
	}

	/**
	 * @return The original element.
	 */
    public T getOriginalElement() {
        return originalElement;
    }

    /**
     * @return The changed element.
     */
    public T getChangedElement() {
        return changedElement;
    }

}