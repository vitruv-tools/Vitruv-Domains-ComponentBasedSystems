package tools.vitruv.domains.java.ui.monitorededitor.methodchange.changeresponder

import tools.vitruv.domains.java.ui.monitorededitor.methodchange.events.MethodBodyChangedEvent
import tools.vitruv.framework.util.datatypes.VURI
import org.emftext.language.java.members.ClassMethod
import org.emftext.language.java.statements.StatementsPackage
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.domains.java.echange.feature.reference.ReferenceFactory
import java.util.Optional
import java.util.ArrayList
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.JavaEditorChange

class MethodBodyChangedVisitor extends VisitorBase<MethodBodyChangedEvent> {

	override protected getTreatedClassInternal() {
		MethodBodyChangedEvent
	}

	override protected visitInternal(MethodBodyChangedEvent changeClassifyingEvent) {
		val originalMethod = changeClassifyingEvent.originalCompilationUnit.
			getMethodOrConstructorForMethodDeclaration(changeClassifyingEvent.originalElement)
		val changedMethod = changeClassifyingEvent.changedCompilationUnit.
			getMethodOrConstructorForMethodDeclaration(changeClassifyingEvent.changedElement)

		val changes = new ArrayList
		val changeURI = VURI.getInstance(originalMethod.eResource)

		for (stmt : (originalMethod as ClassMethod).statements) {
			val change = ReferenceFactory.eINSTANCE.createJavaRemoveEReference();
			// change.isDelete = true;
			change.oldAffectedEObject = originalMethod
			change.affectedEObject = changedMethod
			change.affectedFeature = StatementsPackage.eINSTANCE.statementListContainer_Statements
			change.oldValue = stmt
			change.index = (originalMethod as ClassMethod).statements.indexOf(stmt)
			changes += new JavaEditorChange(change, changeURI)
		}

		for (stmt : (changedMethod as ClassMethod).statements) {
			val change = ReferenceFactory.eINSTANCE.createJavaInsertEReference();
			// change.isCreate = true;
			change.oldAffectedEObject = originalMethod
			change.affectedEObject = changedMethod
			change.affectedFeature = StatementsPackage.eINSTANCE.statementListContainer_Statements
			change.newValue = stmt
			change.index = (changedMethod as ClassMethod).statements.indexOf(stmt)
			changes += new JavaEditorChange(change, changeURI)
		}
		return Optional.of(VitruviusChangeFactory.instance.createCompositeChange(changes))
	}

}
