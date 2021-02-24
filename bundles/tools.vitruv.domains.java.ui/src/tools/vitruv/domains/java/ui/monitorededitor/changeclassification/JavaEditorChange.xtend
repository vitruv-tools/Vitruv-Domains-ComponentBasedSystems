package tools.vitruv.domains.java.ui.monitorededitor.changeclassification

import tools.vitruv.framework.change.description.ConcreteChange
import org.eclipse.xtend.lib.annotations.Delegate
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.framework.uuid.UuidResolver
import tools.vitruv.framework.util.datatypes.VURI
import static com.google.common.base.Preconditions.checkNotNull
import tools.vitruv.framework.change.echange.EChange
import java.util.Set

/**
 * Fixes the VURI of a Vitruvius change because it cannot be derived for the artificial elements
 * created by the editor monitor. Makes the apply methods no-ops because the changes cannot be
 * applied backwards. 
 */
class JavaEditorChange implements ConcreteChange {
	val VURI changedVURI
	@Delegate val ConcreteChange delegate
	
	private new(ConcreteChange delegate, VURI changedVURI) {
		this.delegate = delegate
		this.changedVURI = checkNotNull(changedVURI, "changedVURI")
	}
	
	new(EChange eChange, VURI changedVURI) {
		this(VitruviusChangeFactory.instance.createConcreteChange(eChange), changedVURI)
	}
	
	override getChangedVURIs() {
		Set.of(changedVURI)
	}
	
	override getChangedVURI() {
		changedVURI
	}
	
	override resolveBeforeAndApplyForward(UuidResolver uuidResolver) {
		// not possible
	}

	override resolveAfterAndApplyBackward(UuidResolver uuidResolver) {
		// not possible
	}

	override unresolveIfApplicable() {
		// not applicable
	}
	
	override JavaEditorChange copy() {
		new JavaEditorChange(delegate.copy(), changedVURI)
	}
	
	override equals(Object o) {
		if (this === o) true
		else if (o === null) false
		else if (o instanceof JavaEditorChange) {
			this.changedVURI == o.changedVURI && this.delegate == o.delegate
		}
		else false
	}
	
	override hashCode() {
		changedVURI.hashCode + 43 * delegate.hashCode
	}
}