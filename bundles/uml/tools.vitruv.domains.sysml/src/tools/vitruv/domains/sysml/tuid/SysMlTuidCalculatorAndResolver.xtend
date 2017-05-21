package tools.vitruv.domains.sysml.tuid

import org.eclipse.emf.ecore.EObject
import tools.vitruv.domains.sysml.SysMlDomain
import tools.vitruv.domains.uml.tuid.UmlTuidCalculatorAndResolver

class SysMlTuidCalculatorAndResolver extends UmlTuidCalculatorAndResolver {
	private val extension SysMlToUmlResolver sysMlToUmlResolver;
	
	new(String nsPrefix) {
		super(nsPrefix)
		sysMlToUmlResolver = SysMlToUmlResolver.instance;
	}
	
	override calculateTuidFromEObject(EObject eObject) {
		super.calculateTuidFromEObject(eObject.stereotypedObject);	
	}
	
	override calculateTuidFromEObject(EObject eObject, EObject virtualRootObject, String prefix) {
		if (SysMlDomain.NAMESPACE_URIS.contains(eObject.eClass.getEPackage.nsURI)) {
			super.calculateTuidFromEObject(eObject.stereotypedObject, virtualRootObject, prefix);
		} else {
			super.calculateTuidFromEObject(eObject, virtualRootObject, prefix);
		}
	}
	
}
