package tools.vitruv.domains.uml.tuid

import tools.vitruv.framework.tuid.AttributeTUIDCalculatorAndResolver
import org.eclipse.emf.ecore.EObject
import org.eclipse.uml2.uml.UMLPackage
import org.eclipse.uml2.uml.Generalization

class UmlTuidCalculatorAndResolver extends AttributeTUIDCalculatorAndResolver {
	
	new(String nsPrefix) {
		super(nsPrefix, UMLPackage.Literals.NAMED_ELEMENT__NAME.name)
	}
	
	override calculateIndividualTUIDDelegator(EObject eObject) {
		dispatchedCalculateIndividualTUIDDelegator(eObject);	
	}
	
	def dispatch dispatchedCalculateIndividualTUIDDelegator(EObject eObject) {
		super.calculateIndividualTUIDDelegator(eObject);	
	}
	
	def dispatch dispatchedCalculateIndividualTUIDDelegator(Generalization generalization) {
		// generalization is contained in specific classifier, so with general classifier it should be unique
		//val specific = "specific" + if (generalization.specific != null) "=" + generalization.specific.name else "";
		val general = "general" + if (generalization.general != null) "=" + generalization.general.name else "";
		return (if (generalization.eContainingFeature() == null) "<root>"
					else generalization.eContainingFeature().getName()) + SUBDIVIDER + generalization.eClass().getName() 
						+ SUBDIVIDER + general; 
	}
	
}
