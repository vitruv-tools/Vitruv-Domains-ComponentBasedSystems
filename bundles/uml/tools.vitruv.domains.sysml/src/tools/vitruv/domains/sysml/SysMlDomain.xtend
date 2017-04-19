package tools.vitruv.domains.sysml

import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import org.eclipse.emf.ecore.EObject
import tools.vitruv.domains.sysml.tuid.SysMlToUmlResolver
import tools.vitruv.domains.sysml.tuid.SysMlTuidCalculatorAndResolver
import static tools.vitruv.domains.sysml.SysMlNamspace.*;
import org.eclipse.uml2.uml.UMLPackage
import tools.vitruv.framework.domains.AbstractVitruvDomain

class SysMlDomain extends AbstractVitruvDomain {
	public static final String METAMODEL_NAME = "SysML";
	public static val NAMESPACE_URIS = ROOT_PACKAGE.nsURIsRecursive;
	private val extension SysMlToUmlResolver sysMlToUmlResolver;
	
	package new() {
		super("SysML", ROOT_PACKAGE, #{UMLPackage.eINSTANCE},
			generateTuidCalculator(), FILE_EXTENSION
		);
		sysMlToUmlResolver = SysMlToUmlResolver.instance;
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new SysMlTuidCalculatorAndResolver(METAMODEL_NAMESPACE);
	}
	
	override isInstanceOfDomainMetamodel(EObject eObject) {
		if (eObject === null) {
			return false;
		}
		super.isInstanceOfDomainMetamodel(eObject.stereotypedObject)
	}

}
