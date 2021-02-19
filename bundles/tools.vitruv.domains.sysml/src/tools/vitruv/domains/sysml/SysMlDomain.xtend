package tools.vitruv.domains.sysml

import static tools.vitruv.domains.sysml.SysMlNamspace.*;
import org.eclipse.uml2.uml.UMLPackage
import tools.vitruv.framework.domains.AbstractVitruvDomain

class SysMlDomain extends AbstractVitruvDomain {
	public static final String METAMODEL_NAME = "SysML";
	public static val NAMESPACE_URIS = ROOT_PACKAGE.nsURIsRecursive;
	
	package new() {
		super("SysML", ROOT_PACKAGE, #{UMLPackage.eINSTANCE}, FILE_EXTENSION);
	}

}
