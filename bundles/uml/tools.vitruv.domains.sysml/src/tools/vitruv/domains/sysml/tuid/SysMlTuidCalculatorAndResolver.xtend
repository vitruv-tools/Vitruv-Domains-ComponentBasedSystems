package tools.vitruv.domains.sysml.tuid

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import org.eclipse.emf.ecore.EObject
import org.eclipse.uml2.uml.UMLPackage
import tools.vitruv.domains.sysml.SysMlDomain

class SysMlTuidCalculatorAndResolver extends AttributeTuidCalculatorAndResolver {
	private val extension SysMlToUmlResolver sysMlToUmlResolver;
	//private val UmlMetamodel umlMetamodel;
	
	new(String nsPrefix) {
		super(nsPrefix, UMLPackage.Literals.NAMED_ELEMENT__NAME.name)
		sysMlToUmlResolver = SysMlToUmlResolver.instance;
		//umlMetamodel = UmlMetamodel.instance;
	}
	
	override calculateTuidFromEObject(EObject eObject) {
		//if (SysMlMetamodel.NAMESPACE_URIS.contains(eObject.eClass.EPackage.nsURI)) {
			super.calculateTuidFromEObject(eObject.stereotypedObject);	
//		} else {
//			return umlMetamodel.calculateTuidFromEObject(eObject);
//		}
	}
	
	override calculateTuidFromEObject(EObject eObject, EObject virtualRootObject, String prefix) {
		if (SysMlDomain.NAMESPACE_URIS.contains(eObject.eClass.getEPackage.nsURI)) {
			super.calculateTuidFromEObject(eObject.stereotypedObject, virtualRootObject, prefix);
		} else {
			super.calculateTuidFromEObject(eObject, virtualRootObject, prefix);
//			return umlMetamodel.calculateTuidFromEObject(eObject);
		}
	}
	
}
