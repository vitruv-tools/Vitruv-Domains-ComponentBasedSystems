package tools.vitruv.domains.sysml

import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.domains.sysml.tuid.SysMlTuidCalculatorAndResolver
import static tools.vitruv.domains.sysml.SysMlNamspace.*;
import org.eclipse.uml2.uml.UMLPackage
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain

class SysMlDomain extends AbstractTuidAwareVitruvDomain {
	public static final String METAMODEL_NAME = "SysML";
	public static val NAMESPACE_URIS = ROOT_PACKAGE.nsURIsRecursive;
	
	package new() {
		super("SysML", ROOT_PACKAGE, #{UMLPackage.eINSTANCE},
			generateTuidCalculator(), FILE_EXTENSION
		);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new SysMlTuidCalculatorAndResolver(METAMODEL_NAMESPACE);
	}
	
}
