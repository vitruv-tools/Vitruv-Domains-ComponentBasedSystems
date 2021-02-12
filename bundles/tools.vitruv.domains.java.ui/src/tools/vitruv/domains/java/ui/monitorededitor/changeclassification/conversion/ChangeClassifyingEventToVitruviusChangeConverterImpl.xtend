package tools.vitruv.domains.java.ui.monitorededitor.changeclassification.conversion

import java.util.ArrayList
import java.util.List
import java.util.ListIterator
import java.util.Map
import java.util.Optional
import org.apache.log4j.Logger
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.IPath
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.jdt.core.dom.ASTNode
import org.eclipse.jdt.core.dom.MethodDeclaration
import org.eclipse.jdt.core.dom.SimpleType
import org.eclipse.jdt.core.dom.TypeDeclaration
import org.emftext.language.java.annotations.AnnotationInstance
import org.emftext.language.java.classifiers.Class
import org.emftext.language.java.classifiers.ConcreteClassifier
import org.emftext.language.java.classifiers.Interface
import org.emftext.language.java.commons.NamedElement
import org.emftext.language.java.imports.Import
import org.emftext.language.java.members.Field
import org.emftext.language.java.members.Member
import org.emftext.language.java.members.Method
import org.emftext.language.java.modifiers.AnnotableAndModifiable
import org.emftext.language.java.modifiers.Modifier
import org.emftext.language.java.parameters.Parameter
import org.emftext.language.java.parameters.Parametrizable
import org.emftext.language.java.types.PrimitiveType
import org.emftext.language.java.types.Type
import org.emftext.language.java.types.TypeReference
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.ChangeEventExtendedVisitor
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.ChangeEventVisitor
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.AddAnnotationEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.AddFieldEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.AddImportEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.AddJavaDocEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.AddMethodEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.AddSuperClassEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.AddSuperInterfaceEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeClassModifiersEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeClassifyingEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeClassifyingEventExtension
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeFieldModifiersEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeFieldTypeEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeInterfaceModifiersEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeJavaDocEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeMethodModifiersEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeMethodParameterEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeMethodReturnTypeEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangePackageDeclarationEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.CreateClassEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.CreateInterfaceEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.CreatePackageEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.DeleteClassEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.DeleteInterfaceEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.DeletePackageEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.MoveMethodEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RemoveAnnotationEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RemoveFieldEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RemoveImportEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RemoveJavaDocEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RemoveMethodEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RemoveSuperClassEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RemoveSuperInterfaceEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RenameClassEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RenameFieldEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RenameInterfaceEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RenameMethodEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RenamePackageDeclarationEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RenamePackageEvent
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.RenameParameterEvent
import tools.vitruv.domains.java.ui.monitorededitor.jamopputil.AST2Jamopp
import tools.vitruv.domains.java.ui.monitorededitor.jamopputil.CompilationUnitAdapter
import tools.vitruv.domains.java.ui.monitorededitor.jamopputil.JamoppChangeBuildHelper
import tools.vitruv.framework.change.description.CompositeContainerChange
import tools.vitruv.framework.change.description.ConcreteChange
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.framework.util.datatypes.VURI
import static tools.vitruv.domains.java.ui.monitorededitor.util.ExtensionPointsUtil.getRegisteredChangeEventExtendedVisitors
import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.JavaEditorChange

/** 
 * The {@link ChangeClassifyingEventToVitruviusChangeConverterImpl} implements a{@link ChangeEventVisitor} for {@link ChangeClassifyingEvent}s. It uses the
 * AST information in the change events to build {@link VitruviusChange}s with
 * the {@link JamoppChangeBuildHelper}. It implements the{@link ChangeClassifyingEventToVitruviusChangeConverter} such that a given{@link ChangeClassifyingEvent} can be converted into a{@link VitruviusChange}.
 */
class ChangeClassifyingEventToVitruviusChangeConverterImpl implements ChangeEventVisitor<Optional<VitruviusChange>>, ChangeClassifyingEventToVitruviusChangeConverter {
	static val logger = Logger.getLogger(ChangeClassifyingEventToVitruviusChangeConverterImpl)
	val dispatcher = newDispatcherMap()
	extension val ChangeResponderUtility util = new ChangeResponderUtility()

	def private Map<java.lang.Class<? extends ChangeClassifyingEventExtension>, ChangeEventExtendedVisitor> newDispatcherMap() {
		registeredChangeEventExtendedVisitors.flatMap [ visitor |
			visitor.treatedClasses.map[it -> visitor]
		].toMap([key], [value])
	}

	override Optional<VitruviusChange> convert(ChangeClassifyingEvent event) {
		return event.accept(this)
	}

	override Optional<VitruviusChange> visit(ChangeClassifyingEventExtension changeClassifyingEvent) {
		return dispatcher.get(changeClassifyingEvent.getClass()).visit(changeClassifyingEvent)
	}

	override Optional<VitruviusChange> visit(AddMethodEvent addMethodEvent) {
		val MethodDeclaration newMethodDeclaration = addMethodEvent.method
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(newMethodDeclaration)
		val Parametrizable newMethodOrConstructor = originalCU.
			getMethodOrConstructorForMethodDeclaration(newMethodDeclaration)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(addMethodEvent.typeBeforeAdd)
		val ConcreteClassifier classifierBeforeAdd = changedCU.
			getConcreteClassifierForTypeDeclaration(addMethodEvent.typeBeforeAdd)
		val EChange eChange = JamoppChangeBuildHelper.createAddMethodChange(newMethodOrConstructor, classifierBeforeAdd)
		return createVitruviusChange(eChange, addMethodEvent.method)
	}

	override Optional<VitruviusChange> visit(CreateInterfaceEvent createInterfaceEvent) {
		val type = createInterfaceEvent.type
		val originalCU = getUnsavedCompilationUnitAdapter(createInterfaceEvent.compilationUnitBeforeCreate)
		val changedCU = getUnsavedCompilationUnitAdapter(type)
		val newInterface = (changedCU.getConcreteClassifierForTypeDeclaration(type) as Interface)
		val eChange = JamoppChangeBuildHelper.createCreateInterfaceChange(newInterface,
			if (null === originalCU) null else originalCU.compilationUnit)
		return createVitruviusChange(eChange, createInterfaceEvent.type)
	}

	override Optional<VitruviusChange> visit(CreateClassEvent createClassEvent) {
		val type = createClassEvent.type
		val originalCU = getUnsavedCompilationUnitAdapter(createClassEvent.compilationUnitBeforeCreate)
		val changedCU = getUnsavedCompilationUnitAdapter(type)
		val newClass = (changedCU.getConcreteClassifierForTypeDeclaration(type) as Class)
		val beforeChange = if (null === originalCU) null else originalCU.getCompilationUnit()
		val eChange = JamoppChangeBuildHelper.createAddClassChange(newClass, beforeChange)
		return createVitruviusChange(eChange, createClassEvent.type)
	}

	override Optional<VitruviusChange> visit(ChangeMethodReturnTypeEvent changeMethodReturnTypeEvent) {
		val originalCU = getUnsavedCompilationUnitAdapter(changeMethodReturnTypeEvent.original)
		val original = originalCU.getMethodOrConstructorForMethodDeclaration(changeMethodReturnTypeEvent.original)
		val cu = getUnsavedCompilationUnitAdapter(changeMethodReturnTypeEvent.renamed)
		val changed = cu.getMethodOrConstructorForMethodDeclaration(changeMethodReturnTypeEvent.renamed)
		if (changed instanceof Method && original instanceof Method) {
			val EChange eChange = JamoppChangeBuildHelper.createChangeMethodReturnTypeChange((original as Method),
				(changed as Method))
			return createVitruviusChange(eChange, changeMethodReturnTypeEvent.original)
		} else {
			logger.
				info('''Change method return type could not be reported. Either original or changed is not instanceof method: orginal:  changed: «changed»''')
			return Optional.empty()
		}
	}

	override Optional<VitruviusChange> visit(RemoveMethodEvent removeMethodEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(removeMethodEvent.method)
		val Parametrizable removedMethod = originalCU.
			getMethodOrConstructorForMethodDeclaration(removeMethodEvent.method)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			removeMethodEvent.typeAfterRemove)
		val ConcreteClassifier classifierAfterRemove = changedCU.
			getConcreteClassifierForTypeDeclaration(removeMethodEvent.typeAfterRemove)
		val EChange eChange = JamoppChangeBuildHelper.createRemoveMethodChange(removedMethod, classifierAfterRemove)
		return createVitruviusChange(eChange, removeMethodEvent.method)
	}

	override Optional<VitruviusChange> visit(DeleteClassEvent deleteClassEvent) {
		val TypeDeclaration type = deleteClassEvent.type
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(type)
		val Class deletedClass = (originalCU.getConcreteClassifierForTypeDeclaration(type) as Class)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			deleteClassEvent.compilationUnitAfterDelete)
		val eChange = JamoppChangeBuildHelper.createRemovedClassChange(deletedClass, changedCU.compilationUnit)
		return createVitruviusChange(eChange, deleteClassEvent.type)
	}

	override Optional<VitruviusChange> visit(DeleteInterfaceEvent deleteInterfaceEvent) {
		val TypeDeclaration type = deleteInterfaceEvent.type
		val CompilationUnitAdapter oldCU = getUnsavedCompilationUnitAdapter(type)
		val Interface deletedInterface = (oldCU.getConcreteClassifierForTypeDeclaration(type) as Interface)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			deleteInterfaceEvent.compilationUnitAfterDelete)
		val EChange eChange = JamoppChangeBuildHelper.createRemovedInterfaceChange(deletedInterface,
			changedCU.getCompilationUnit())
		return createVitruviusChange(eChange, deleteInterfaceEvent.type)
	}

	override Optional<VitruviusChange> visit(RenameMethodEvent renameMethodEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(renameMethodEvent.original)
		val Parametrizable original = originalCU.getMethodOrConstructorForMethodDeclaration(renameMethodEvent.original)
		val URI uri = getFirstExistingURI(renameMethodEvent.renamed, renameMethodEvent.original)
		val CompilationUnitAdapter changedCU = 
			getUnsavedCompilationUnitAdapter(renameMethodEvent.renamed, uri)
		val Parametrizable changed = changedCU.getMethodOrConstructorForMethodDeclaration(renameMethodEvent.renamed)
		if (changed instanceof Member && original instanceof Member) {
			val EChange eChange = JamoppChangeBuildHelper.createRenameMethodChange((original as Member),
				(changed as Member))
			return createVitruviusChange(eChange, renameMethodEvent.original)
		} else {
			logger.
				info('''Could not execute rename method event, cause original or changed is not instance of Member. Original: «original» Changed: «changed»''')
			return Optional.empty()
		}
	}

	override Optional<VitruviusChange> visit(RenameFieldEvent renameFieldEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(renameFieldEvent.original)
		val Field original = originalCU.getFieldForVariableDeclarationFragment(renameFieldEvent.originalFragment)
		val URI uri = getFirstExistingURI(renameFieldEvent.changed, renameFieldEvent.original)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(renameFieldEvent.changed, uri)
		val Field renamed = changedCU.getFieldForVariableDeclarationFragment(renameFieldEvent.changedFragment)
		val EChange eChange = JamoppChangeBuildHelper.createRenameFieldChange(original, renamed)
		return createVitruviusChange(eChange, renameFieldEvent.original)
	}

	override Optional<VitruviusChange> visit(RenameInterfaceEvent renameInterfaceEvent) {
		val CompilationUnitAdapter originalCU = 
			getUnsavedCompilationUnitAdapter(renameInterfaceEvent.original)
		val Interface originalInterface = (originalCU.
			getConcreteClassifierForTypeDeclaration(renameInterfaceEvent.original) as Interface)
		val URI uri = getFirstExistingURI(renameInterfaceEvent.renamed, renameInterfaceEvent.original)
		val CompilationUnitAdapter cuRenamed = getUnsavedCompilationUnitAdapter(renameInterfaceEvent.renamed,
			uri)
		val Interface renamedInterface = (cuRenamed.
			getConcreteClassifierForTypeDeclaration(renameInterfaceEvent.renamed) as Interface)
		val EChange eChange = JamoppChangeBuildHelper.createRenameInterfaceChange(originalInterface, renamedInterface)
		return createVitruviusChange(eChange, renameInterfaceEvent.original)
	}

	override Optional<VitruviusChange> visit(RenameClassEvent renameClassEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(renameClassEvent.original)
		val Class originalClass = (originalCU.
			getConcreteClassifierForTypeDeclaration(renameClassEvent.original) as Class)
		val URI uri = getFirstExistingURI(renameClassEvent.renamed, renameClassEvent.original)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(renameClassEvent.renamed, uri)
		val Class renamedClass = (changedCU.getConcreteClassifierForTypeDeclaration(renameClassEvent.renamed) as Class)
		val EChange eChange = JamoppChangeBuildHelper.createRenameClassChange(originalClass, renamedClass)
		return createVitruviusChange(eChange, renameClassEvent.original)
	}

	override Optional<VitruviusChange> visit(AddImportEvent addImportEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(
			addImportEvent.importDeclaration)
		val Import imp = originalCU.getImportForImportDeclaration(addImportEvent.importDeclaration)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			addImportEvent.compilationUnitBeforeAdd)
		val EChange eChange = JamoppChangeBuildHelper.createAddImportChange(imp, changedCU.getCompilationUnit())
		return createVitruviusChange(eChange, addImportEvent.importDeclaration)
	}

	override Optional<VitruviusChange> visit(RemoveImportEvent removeImportEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(
			removeImportEvent.importDeclaration)
		val Import imp = originalCU.getImportForImportDeclaration(removeImportEvent.importDeclaration)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			removeImportEvent.compilationUnitAfterRemove)
		val EChange eChange = JamoppChangeBuildHelper.createRemoveImportChange(imp, changedCU.getCompilationUnit())
		return createVitruviusChange(eChange, removeImportEvent.importDeclaration)
	}

	override Optional<VitruviusChange> visit(MoveMethodEvent moveMethodEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(moveMethodEvent.original)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(moveMethodEvent.moved)
		val ConcreteClassifier classifierMovedFromAfterRemove = originalCU.getConcreteClassifierForTypeDeclaration(
			moveMethodEvent.typeMovedFromAfterRemove)
		val ConcreteClassifier classifierMovedToBeforeAdd = originalCU.
			getConcreteClassifierForTypeDeclaration(moveMethodEvent.typeMovedToBeforeAdd)
		val Parametrizable removedParametrizable = originalCU.
			getMethodOrConstructorForMethodDeclaration(moveMethodEvent.original)
		val Parametrizable addedParametrizable = changedCU.
			getMethodOrConstructorForMethodDeclaration(moveMethodEvent.moved)
		if (removedParametrizable instanceof Method && addedParametrizable instanceof Method) {
			val Method addedMethod = (addedParametrizable as Method)
			val Method removedMethod = (removedParametrizable as Method)
			val EChange[] eChanges = JamoppChangeBuildHelper.createMoveMethodChange(removedMethod,
				classifierMovedFromAfterRemove, addedMethod, classifierMovedToBeforeAdd)
			// [0] is remove, [1] is add
			val ConcreteChange removeMethodChange = wrapToVitruviusModelChange(eChanges.get(0),
				moveMethodEvent.original)
			val ConcreteChange addMethodChange = wrapToVitruviusModelChange(eChanges.get(1),
				moveMethodEvent.moved)
			return Optional.of(
				VitruviusChangeFactory.instance.createCompositeChange(
					List.of(removeMethodChange, addMethodChange)))
		} else {
			logger.
				info('''could not report move method because either added or removed method is not a method. Added: «addedParametrizable» Removed: «removedParametrizable»''')
			return Optional.empty()
		}
	}

	override Optional<VitruviusChange> visit(AddSuperInterfaceEvent addSuperInterfaceEvent) {
		val CompilationUnitAdapter originalCU = 
			getUnsavedCompilationUnitAdapter(addSuperInterfaceEvent.baseType)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			addSuperInterfaceEvent.superType)
		if (!(addSuperInterfaceEvent.superType instanceof SimpleType)) {
			logger.
				warn('''visit AddSuperInterfaceEvent failed: super type is not an instance of SimpleType: «addSuperInterfaceEvent.superType»''')
			return Optional.empty()
		}
		val TypeReference implementsTypeRef = changedCU.getImplementsForSuperType(
			(addSuperInterfaceEvent.superType as SimpleType))
		val ConcreteClassifier affectedClassifier = originalCU.
			getConcreteClassifierForTypeDeclaration(addSuperInterfaceEvent.baseType)
		val EChange eChange = JamoppChangeBuildHelper.createAddSuperInterfaceChange(affectedClassifier,
			implementsTypeRef)
		return createVitruviusChange(eChange, addSuperInterfaceEvent.baseType)
	}

	override Optional<VitruviusChange> visit(RemoveSuperInterfaceEvent removeSuperInterfaceEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(
			removeSuperInterfaceEvent.baseType)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			removeSuperInterfaceEvent.superType)
		if (!(removeSuperInterfaceEvent.superType instanceof SimpleType)) {
			logger.
				warn('''visit AddSuperInterfaceEvent failed: super type is not an instance of SimpleType: «removeSuperInterfaceEvent.superType»''')
			return Optional.empty()
		}
		val TypeReference implementsTypeRef = originalCU.getImplementsForSuperType(
			(removeSuperInterfaceEvent.superType as SimpleType))
		val ConcreteClassifier affectedClassifier = changedCU.
			getConcreteClassifierForTypeDeclaration(removeSuperInterfaceEvent.baseType)
		val EChange eChange = JamoppChangeBuildHelper.createRemoveSuperInterfaceChange(affectedClassifier,
			implementsTypeRef)
		return createVitruviusChange(eChange, removeSuperInterfaceEvent.baseType)
	}

	override Optional<VitruviusChange> visit(AddSuperClassEvent addSuperClassEvent) {
		logger.warn("AddSuperClassEvent not supported yet")
		return Optional.empty()
	}

	override Optional<VitruviusChange> visit(RemoveSuperClassEvent removeSuperClassEvent) {
		logger.warn("RemoveSuperClassEvent not supported yet")
		return Optional.empty()
	}

	override Optional<VitruviusChange> visit(ChangeMethodParameterEvent changeMethodParameterEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(
			changeMethodParameterEvent.original)
		val Parametrizable original = originalCU.
			getMethodOrConstructorForMethodDeclaration(changeMethodParameterEvent.original)
		val CompilationUnitAdapter cu = getUnsavedCompilationUnitAdapter(changeMethodParameterEvent.renamed)
		val Parametrizable changed = cu.getMethodOrConstructorForMethodDeclaration(changeMethodParameterEvent.renamed)
		return handleParameterChanges(changed, original, original.getParameters(), changed.getParameters(),
			changeMethodParameterEvent.original)
	}

	def private Optional<VitruviusChange> handleParameterChanges(Parametrizable methodAfterRemove,
		Parametrizable methodBeforeAdd, List<Parameter> oldParameters, List<Parameter> newParameters, ASTNode oldNode) {
		val List<ConcreteChange> changes = new ArrayList()
		/*
		 * for (final Parameter oldParameter : oldParameters) { final EChange eChange =
		 * JaMoPPChangeBuildHelper.createRemoveParameterChange(oldParameter,
		 * methodAfterRemove);
		 * compositeChange.addChange(wrapToEMFModelChange(eChange, oldNode));
		 * } for (final Parameter newParameter : newParameters) { final EChange eChange
		 * = JaMoPPChangeBuildHelper.createAddParameterChange(newParameter,
		 * methodBeforeAdd);
		 * compositeChange.addChange(wrapToEMFModelChange(eChange, oldNode));
		 * }
		 */
		// diff the parameter list to figure out which parameters are added respectievly
		// removed
		for (Parameter oldParameter : oldParameters) {
			if (!containsParameter(oldParameter, newParameters)) {
				// old Parameter is no longer contained in newParameters list
				val EChange eChange = JamoppChangeBuildHelper.createRemoveParameterChange(oldParameter,
					methodAfterRemove)
				changes.add(wrapToVitruviusModelChange(eChange, oldNode))
			}
		}
		for (Parameter newParameter : newParameters) {
			if (!containsParameter(newParameter, oldParameters)) {
				// new Parameter is not contained in oldParameters list --> new Parameter has
				// been created
				val EChange eChange = JamoppChangeBuildHelper.createAddParameterChange(newParameter, methodBeforeAdd)
				changes.add(wrapToVitruviusModelChange(eChange, oldNode))
			}
		}
		return Optional.of(VitruviusChangeFactory.instance.createCompositeChange(changes))
	}

	def package boolean containsParameter(Parameter parameter, List<Parameter> parameterList) {
		for (Parameter parameterInList : parameterList) {
			// we consider parameters equal if they name is identical, the return type is
			// identical, and they arrayDimension is equal
			if (parameterInList.getName().equals(parameter.getName()) &&
				targetInTypeReferenceEquals(parameter.getTypeReference(), parameterInList.getTypeReference()) &&
				parameterInList.getArrayDimension() === parameter.getArrayDimension()) {
				return true
			}
		}
		return false
	}

	def private boolean targetInTypeReferenceEquals(TypeReference typeRef1, TypeReference typeRef2) {
		if (typeRef1.getTarget() === null && typeRef2.getTarget() === null) {
			return true
		}
		if (typeRef1.getTarget() === null) {
			return false
		}
		if (typeRef2.getTarget() === null) {
			return false
		}
		if (!typeEquals(typeRef1.getTarget(), typeRef2.getTarget())) {
			return false
		}
		return true
	}

	def private static boolean typeEquals(Type type1, Type type2) {
		if (type1 === type2) {
			return true
		}
		val boolean sameType = type1.getClass().equals(type2.getClass())
		if (!sameType) {
			// both types have to be from the same type e.g. ConcreteClassifier
			return false
		}
		if (type1 instanceof PrimitiveType && type2 instanceof PrimitiveType) {
			// both have the same type and they are primitive types-->same type
			return true
		}
		if (type1 instanceof NamedElement && type2 instanceof NamedElement) {
			val NamedElement ne1 = (type1 as NamedElement)
			val NamedElement ne2 = (type2 as NamedElement)
			return ne1.getName().equals(ne2.getName())
		}
		return false
	}

	override Optional<VitruviusChange> visit(ChangeMethodModifiersEvent changeMethodModifierEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(
			changeMethodModifierEvent.original)
		val Parametrizable originalMethod = originalCU.
			getMethodOrConstructorForMethodDeclaration(changeMethodModifierEvent.original)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			changeMethodModifierEvent.renamed)
		val Parametrizable changedMethod = changedCU.
			getMethodOrConstructorForMethodDeclaration(changeMethodModifierEvent.renamed)
		if (originalMethod instanceof AnnotableAndModifiable && changedMethod instanceof AnnotableAndModifiable) {
			val AnnotableAndModifiable originalModifiable = (originalMethod as AnnotableAndModifiable)
			val AnnotableAndModifiable changedModifiable = (changedMethod as AnnotableAndModifiable)
			val CompositeContainerChange change = buildModifierChanges(originalMethod, changedMethod,
				originalModifiable.getModifiers(), changedModifiable.getModifiers(), changeMethodModifierEvent.original)
			return Optional.of(change)
		} else {
			logger.
				info('''ChangeMethodModifiersEvent type could not be reported. Either original or changed is not instanceof Modifiable: orginal: «originalMethod» changed: «changedMethod»''')
			return Optional.empty()
		}
	}

	override Optional<VitruviusChange> visit(ChangeClassModifiersEvent changeClassModifiersEvent) {
		return handleClassifierModifierChanges(changeClassModifiersEvent.original,
			changeClassModifiersEvent.changed)
	}

	override Optional<VitruviusChange> visit(ChangeInterfaceModifiersEvent changeInterfaceModifiersEvent) {
		return handleClassifierModifierChanges(changeInterfaceModifiersEvent.original,
			changeInterfaceModifiersEvent.changed)
	}

	def private Optional<VitruviusChange> handleClassifierModifierChanges(TypeDeclaration original,
		TypeDeclaration changed) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(original)
		val ConcreteClassifier originalClassifier = originalCU.getConcreteClassifierForTypeDeclaration(original)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(changed)
		val ConcreteClassifier changedClassifier = changedCU.getConcreteClassifierForTypeDeclaration(changed)
		val CompositeContainerChange change = buildModifierChanges(originalClassifier, changedClassifier,
			originalClassifier.getModifiers(), changedClassifier.getModifiers(), original)
		return Optional.of(change)
	}

	def private CompositeContainerChange buildModifierChanges(EObject modifiableBeforeChange,
		EObject modifiableAfterChange, List<Modifier> oldModifiers, List<Modifier> newModifiers, ASTNode oldNode) {
		val List<Modifier> originalModifiers = new ArrayList<Modifier>(oldModifiers)
		val List<Modifier> changedModifiers = new ArrayList<Modifier>(newModifiers)
		for (Modifier changedModifier : newModifiers) {
			val origModifier = oldModifiers.findFirst [it.class == changedModifier.class]
			if (origModifier !== null) {
				originalModifiers.remove(origModifier)
				changedModifiers.remove(changedModifier)
			}
		}
		val List<ConcreteChange> modifierChanges = new ArrayList()
		for (Modifier removedModifier : originalModifiers) {
			val EChange eChange = JamoppChangeBuildHelper.createRemoveAnnotationOrModifierChange(removedModifier,
				modifiableAfterChange)
			modifierChanges.add(wrapToVitruviusModelChange(eChange, oldNode))
		}
		for (Modifier newModifier : changedModifiers) {
			val EChange eChange = JamoppChangeBuildHelper.createAddAnnotationOrModifierChange(newModifier,
				modifiableBeforeChange)
			modifierChanges.add(wrapToVitruviusModelChange(eChange, oldNode))
		}
		return VitruviusChangeFactory.instance.createCompositeChange(modifierChanges)
	}

	override Optional<VitruviusChange> visit(AddFieldEvent addFieldEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(addFieldEvent.typeBeforeAdd)
		val ConcreteClassifier classifierBeforeAdd = originalCU.
			getConcreteClassifierForTypeDeclaration(addFieldEvent.typeBeforeAdd)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(addFieldEvent.field)
		val Field field = changedCU.getFieldForVariableDeclarationFragment(addFieldEvent.fieldFragment)
		val EChange eChange = JamoppChangeBuildHelper.createAddFieldChange(field, classifierBeforeAdd)
		return createVitruviusChange(eChange, addFieldEvent.field)
	}

	override Optional<VitruviusChange> visit(RemoveFieldEvent removeFieldEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(removeFieldEvent.field)
		val Field field = originalCU.getFieldForVariableDeclarationFragment(removeFieldEvent.fieldFragment)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			removeFieldEvent.typeAfterRemove)
		val ConcreteClassifier classiferAfterRemove = changedCU.
			getConcreteClassifierForTypeDeclaration(removeFieldEvent.typeAfterRemove)
		val EChange eChange = JamoppChangeBuildHelper.createAddFieldChange(field, classiferAfterRemove)
		return createVitruviusChange(eChange, removeFieldEvent.field)
	}

	override Optional<VitruviusChange> visit(ChangeFieldModifiersEvent changeFieldModifiersEvent) {
		val CompilationUnitAdapter originalCU = getUnsavedCompilationUnitAdapter(
			changeFieldModifiersEvent.original)
		val List<Field> originalFields = originalCU.getFieldsForFieldDeclaration(changeFieldModifiersEvent.original)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(
			changeFieldModifiersEvent.changed)
		val List<Field> changedFields = changedCU.getFieldsForFieldDeclaration(changeFieldModifiersEvent.changed)
		val List<VitruviusChange> allFieldModifierChanges = new ArrayList()
		val ListIterator<Field> ofit = originalFields.listIterator()
		while (ofit.hasNext()) {
			val Field oField = ofit.next()
			val ListIterator<Field> cfit = changedFields.listIterator()
			while (cfit.hasNext()) {
				val Field cField = cfit.next()
				if (oField.getName().equals(cField.getName())) {
					cfit.remove()
					val CompositeContainerChange fieldModifierChanges = buildModifierChanges(oField, cField,
						oField.getModifiers(), cField.getModifiers(), changeFieldModifiersEvent.original)
					allFieldModifierChanges.add(fieldModifierChanges)
				}
			}
		}
		return Optional.of(VitruviusChangeFactory.instance.createCompositeChange(allFieldModifierChanges))
	}

	override Optional<VitruviusChange> visit(ChangeFieldTypeEvent changeFieldTypeEvent) {
		val CompilationUnitAdapter originalCU = 
			getUnsavedCompilationUnitAdapter(changeFieldTypeEvent.original)
		val List<Field> originalFields = originalCU.getFieldsForFieldDeclaration(changeFieldTypeEvent.original)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(changeFieldTypeEvent.changed)
		val List<Field> changedFields = changedCU.getFieldsForFieldDeclaration(changeFieldTypeEvent.changed)
		val List<ConcreteChange> typeChanges = new ArrayList()
		val ListIterator<Field> ofit = originalFields.listIterator()
		while (ofit.hasNext()) {
			val Field oField = ofit.next()
			val ListIterator<Field> cfit = changedFields.listIterator()
			while (cfit.hasNext()) {
				val Field cField = cfit.next()
				if (oField.getName().equals(cField.getName())) {
					cfit.remove()
					val EChange eChange = JamoppChangeBuildHelper.createChangeFieldTypeChange(oField, cField)
					typeChanges.add(wrapToVitruviusModelChange(eChange, changeFieldTypeEvent.original))
				}
			}
		}
		return Optional.of(VitruviusChangeFactory.instance.createCompositeChange(typeChanges))
	}

	override Optional<VitruviusChange> visit(AddAnnotationEvent addAnnotationEvent) {
		logger.info("React to AddMethodAnnotationEvent")
		val CompilationUnitAdapter oldCU = getUnsavedCompilationUnitAdapter(
			addAnnotationEvent.bodyDeclaration)
		val AnnotableAndModifiable annotableAndModifiable = oldCU.
			getAnnotableAndModifiableForBodyDeclaration(addAnnotationEvent.bodyDeclaration)
		val CompilationUnitAdapter newCu = getUnsavedCompilationUnitAdapter(addAnnotationEvent.annotation)
		val AnnotationInstance annotationInstance = newCu.
			getAnnotationInstanceForMethodAnnotation(addAnnotationEvent.annotation, addAnnotationEvent.bodyDeclaration)
		if (null !== annotationInstance) {
			val EChange eChange = JamoppChangeBuildHelper.createAddAnnotationOrModifierChange(annotationInstance,
				annotableAndModifiable)
			return createVitruviusChange(eChange, addAnnotationEvent.annotation)
		}
		return Optional.empty()
	}

	override Optional<VitruviusChange> visit(RemoveAnnotationEvent removeAnnotationEvent) {
		val CompilationUnitAdapter cuWithAnnotation = getUnsavedCompilationUnitAdapter(
			removeAnnotationEvent.annotation)
		val AnnotationInstance removedAnnotation = cuWithAnnotation.
			getAnnotationInstanceForMethodAnnotation(removeAnnotationEvent.annotation,
				removeAnnotationEvent.bodyAfterChange)
		if (null !== removedAnnotation) {
			val CompilationUnitAdapter cuWithoutAnnotation = getUnsavedCompilationUnitAdapter(
				removeAnnotationEvent.bodyAfterChange)
			val AnnotableAndModifiable annotableAndModifiable = cuWithoutAnnotation.
				getAnnotableAndModifiableForBodyDeclaration(removeAnnotationEvent.bodyAfterChange)
			val EChange eChange = JamoppChangeBuildHelper.createRemoveAnnotationOrModifierChange(removedAnnotation,
				annotableAndModifiable)
			return createVitruviusChange(eChange, removeAnnotationEvent.annotation)
		}
		return Optional.empty()
	}

	override Optional<VitruviusChange> visit(RenamePackageEvent renamePackageEvent) {
		val EChange renamePackageChange = JamoppChangeBuildHelper.createRenamePackageChange(
			renamePackageEvent.originalPackageName, renamePackageEvent.renamedPackageName)
		return createVitruviusModelChange(renamePackageChange, renamePackageEvent.originalIResource)
	}

	override Optional<VitruviusChange> visit(DeletePackageEvent deletePackageEvent) {
		val EChange deletePackageChange = JamoppChangeBuildHelper.createDeletePackageChange(
			deletePackageEvent.packageName)
		return createVitruviusModelChange(deletePackageChange, deletePackageEvent.iResource)
	}

	override Optional<VitruviusChange> visit(CreatePackageEvent addPackageEvent) {
		val EChange createPackageChange = JamoppChangeBuildHelper.createCreatePackageChange(addPackageEvent.packageName)
		return createVitruviusModelChange(createPackageChange, addPackageEvent.iResource)
	}

	override Optional<VitruviusChange> visit(RenameParameterEvent renameParameterEvent) {
		val CompilationUnitAdapter originalCU = 
			getUnsavedCompilationUnitAdapter(renameParameterEvent.original)
		val Parameter original = originalCU.getParameterForVariableDeclaration(renameParameterEvent.originalParam)
		val URI uri = getFirstExistingURI(renameParameterEvent.original, renameParameterEvent.renamed)
		val CompilationUnitAdapter changedCU = getUnsavedCompilationUnitAdapter(renameParameterEvent.renamed,
			uri)
		val Parameter renamed = changedCU.getParameterForVariableDeclaration(renameParameterEvent.changedParam)
		val EChange eChange = JamoppChangeBuildHelper.createRenameParameterChange(original, renamed)
		return createVitruviusChange(eChange, renameParameterEvent.original)
	}

	override Optional<VitruviusChange> visit(RenamePackageDeclarationEvent renamePackageDeclarationEvent) {
		logger.warn("RenamePackageDeclarationEvent not supported yet")
		return Optional.empty()
	}

	override Optional<VitruviusChange> visit(ChangePackageDeclarationEvent changePackageDeclarationEvent) {
		logger.warn("ChangePackageDeclarationEvent not supported yet")
		return Optional.empty()
	}

	override Optional<VitruviusChange> visit(AddJavaDocEvent addJavaDocEvent) {
		return Optional.empty()
	}

	override Optional<VitruviusChange> visit(RemoveJavaDocEvent removeJavaDocEvent) {
		return Optional.empty()
	}

	override Optional<VitruviusChange> visit(ChangeJavaDocEvent changeJavaDocEvent) {
		return Optional.empty()
	}

	protected static final class ChangeResponderUtility {
		def CompilationUnitAdapter getUnsavedCompilationUnitAdapter(ASTNode astNode) {
			val URI uri = getURIFromCompilationUnit(astNode)
			return getUnsavedCompilationUnitAdapter(astNode, uri)
		}

		def CompilationUnitAdapter getUnsavedCompilationUnitAdapter(ASTNode astNode, URI uri) {
			var CompilationUnitAdapter cu = null
			if (null === astNode) {
				return null
			}
			cu = new CompilationUnitAdapter(astNode, uri, false)
			if (cu.getCompilationUnit() === null) {
				cu = null
			}
			return cu
		}

		def private Optional<VitruviusChange> createVitruviusChange(EChange eChange, ASTNode astNodeWithIResource) {
			Optional.of(wrapToVitruviusModelChange(eChange, astNodeWithIResource))
		}

		def private Optional<VitruviusChange> createVitruviusModelChange(EChange eChange, IResource originalIResource) {
			Optional.of(wrapToVitruviusModelChange(eChange, originalIResource))
		}

		def private ConcreteChange wrapToVitruviusModelChange(EChange eChange, ASTNode astNodeWithIResource) {
			wrapToVitruviusModelChange(eChange, AST2Jamopp.getIResource(astNodeWithIResource))
		}

		def private ConcreteChange wrapToVitruviusModelChange(EChange eChange, IResource originalIResource) {
			new JavaEditorChange(eChange, VURI.getInstance(originalIResource))
		}

		// returns URI from node1 if exists, otherwise URI from node2 or null if both
		// have no attached IResource
		def package URI getFirstExistingURI(ASTNode node1, ASTNode node2) {
			var URI uri = getURIFromCompilationUnit(node1)
			if (uri === null) {
				uri = getURIFromCompilationUnit(node2)
			}
			return uri
		}

		def private URI getURIFromCompilationUnit(ASTNode astNode) {
			// TODO IPath for CompilationUnit without linked IResource
			// IPath iPath = AST2JaMoPP.getIPathFromCompilationUnitWithResource(astNode);
			val IResource iResource = AST2Jamopp.getIResource(astNode)
			if (null === iResource) {
				return null
			}
			val IPath iPath = iResource.getFullPath()
			if (iPath === null) {
				return null
			}
			return URI.createPlatformResourceURI(iPath.toString(), true)
		}
	}
}
