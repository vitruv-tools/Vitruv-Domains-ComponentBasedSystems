package tools.vitruv.domains.uml.tuid

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import org.eclipse.emf.ecore.EObject
import org.eclipse.uml2.uml.UMLPackage
import org.eclipse.uml2.uml.Generalization
import org.eclipse.uml2.uml.PackageImport

class UmlTuidCalculatorAndResolver extends AttributeTuidCalculatorAndResolver {
	
	new(String nsPrefix) {
		super(nsPrefix, UMLPackage.Literals.NAMED_ELEMENT__NAME.name)
	}
	
	override calculateIndividualTuidDelegator(EObject eObject) {
		dispatchedCalculateIndividualTuidDelegator(eObject);	
	}
	
	def dispatch String dispatchedCalculateIndividualTuidDelegator(EObject eObject) {
		super.calculateIndividualTuidDelegator(eObject);	
	}
	
	def dispatch String dispatchedCalculateIndividualTuidDelegator(Generalization generalization) {
		// generalization is contained in specific classifier, so with general classifier it should be unique
		//val specific = "specific" + if (generalization.specific != null) "=" + generalization.specific.name else "";
		val general = "general" + if (generalization.general != null) "=" + generalization.general.name else "";
		return (if (generalization.eContainingFeature() == null) "<root>"
					else generalization.eContainingFeature().getName()) + SUBDIVIDER + generalization.eClass().getName() 
						+ SUBDIVIDER + general; 
	}
	
	def dispatch String dispatchedCalculateIndividualTuidDelegator(PackageImport packageImport) {
		val pckg = "package" + if (packageImport.importedPackage != null) "=" + packageImport.importedPackage.name else "";
		return (if (packageImport.eContainingFeature == null) "<root>" else packageImport.eContainingFeature.name) + 
			SUBDIVIDER + packageImport.eClass.name + SUBDIVIDER + pckg;
	}
}
