package tools.vitruv.domains.java.monitorededitor.methodchange.changeresponder

import tools.vitruv.domains.java.monitorededitor.methodchange.events.MethodBodyChangedEvent
import tools.vitruv.framework.util.datatypes.VURI
import tools.vitruv.domains.java.monitorededitor.ChangeSubmitter
import org.emftext.language.java.members.ClassMethod
import org.emftext.language.java.statements.StatementsPackage
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.domains.java.echange.feature.reference.ReferenceFactory

class MethodBodyChangedVisitor extends VisitorBase<MethodBodyChangedEvent> {
	
	override protected getTreatedClassInternal() {
		MethodBodyChangedEvent
	}
	
	override protected visitInternal(MethodBodyChangedEvent changeClassifyingEvent, ChangeSubmitter submitter) {
		val originalMethod = changeClassifyingEvent.originalCompilationUnit.getMethodOrConstructorForMethodDeclaration(changeClassifyingEvent.originalElement)
		val changedMethod = changeClassifyingEvent.changedCompilationUnit.getMethodOrConstructorForMethodDeclaration(changeClassifyingEvent.changedElement)
 
		val compositeChange = VitruviusChangeFactory.instance.createCompositeTransactionalChange();
		val changeURI = VURI.getInstance(originalMethod.eResource)

		for (stmt : (originalMethod as ClassMethod).statements) {
			val change = ReferenceFactory.eINSTANCE.createJavaRemoveEReference();
			//change.isDelete = true;
			change.oldAffectedEObject = originalMethod
			change.affectedEObject = changedMethod
			change.affectedFeature = StatementsPackage.eINSTANCE.statementListContainer_Statements
			change.oldValue = stmt
			change.index = (originalMethod as ClassMethod).statements.indexOf(stmt)
			compositeChange.addChange(VitruviusChangeFactory.instance.createConcreteChangeWithVuri(change, changeURI))
		}
		
		for (stmt : (changedMethod as ClassMethod).statements) {
			val change = ReferenceFactory.eINSTANCE.createJavaInsertEReference();
			//change.isCreate = true;
			change.oldAffectedEObject = originalMethod
			change.affectedEObject = changedMethod
			change.affectedFeature = StatementsPackage.eINSTANCE.statementListContainer_Statements
			change.newValue = stmt
			change.index = (changedMethod as ClassMethod).statements.indexOf(stmt)
			compositeChange.addChange(VitruviusChangeFactory.instance.createConcreteChangeWithVuri(change, changeURI))
		}
		submitter.submitChange(compositeChange)
	}
	
}