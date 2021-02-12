package tools.vitruv.domains.java.ui.monitorededitor.methodchange.changeresponder

import org.eclipse.emf.ecore.EAttribute
import tools.vitruv.framework.util.datatypes.VURI
import tools.vitruv.domains.java.ui.monitorededitor.methodchange.events.MethodParameterNameChangedEvent
import tools.vitruv.domains.java.echange.feature.attribute.AttributeFactory
import java.util.Optional
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.JavaEditorChange

class MethodParameterNameChangedVisitor extends VisitorBase<MethodParameterNameChangedEvent> {

	override protected getTreatedClassInternal() {
		return MethodParameterNameChangedEvent
	}

	override protected visitInternal(MethodParameterNameChangedEvent changeClassifyingEvent) {
		val originalMethod = changeClassifyingEvent.originalCompilationUnit.
			getMethodOrConstructorForMethodDeclaration(changeClassifyingEvent.originalElement)
		val changedMethod = changeClassifyingEvent.changedCompilationUnit.
			getMethodOrConstructorForMethodDeclaration(changeClassifyingEvent.changedElement)
		val originalParam = originalMethod.parameters.findFirst [
			name.equals(changeClassifyingEvent.paramOriginal.name.identifier)
		]
		val changedParam = changedMethod.parameters.findFirst [
			name.equals(changeClassifyingEvent.paramChanged.name.identifier)
		]

		val change = AttributeFactory.eINSTANCE.createJavaReplaceSingleValuedEAttribute
		change.affectedEObject = changedParam
		change.oldAffectedEObject = originalParam
		change.affectedFeature = originalParam.eClass.getEStructuralFeature("name") as EAttribute
		change.newValue = change.affectedEObject.eGet(change.affectedFeature)
		change.oldValue = change.oldAffectedEObject.eGet(change.affectedFeature)

		return Optional.of(new JavaEditorChange(change, VURI.getInstance(change.oldAffectedEObject.eResource)))
	}

}
