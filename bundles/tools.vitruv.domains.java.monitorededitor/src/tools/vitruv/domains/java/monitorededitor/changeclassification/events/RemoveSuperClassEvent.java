package tools.vitruv.domains.java.monitorededitor.changeclassification.events;

import org.eclipse.jdt.core.dom.Type;
import org.eclipse.jdt.core.dom.TypeDeclaration;

import tools.vitruv.domains.java.monitorededitor.changeclassification.ChangeEventVisitor;

public class RemoveSuperClassEvent extends ChangedSuperTypesEvent {

	public RemoveSuperClassEvent(TypeDeclaration baseType, Type superClass) {
		super(baseType, superClass);
	}

	@Override
	public String toString() {
		return "RemoveSuperClassEvent  [baseType: " + this.baseType.getName() + ", superClass: " + this.superType + "]";
	}

	@Override
	public <T> T accept(final ChangeEventVisitor<T> visitor) {
		return visitor.visit(this);
	}

}
