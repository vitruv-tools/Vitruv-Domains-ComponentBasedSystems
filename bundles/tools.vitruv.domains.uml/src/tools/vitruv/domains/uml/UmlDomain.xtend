package tools.vitruv.domains.uml

import org.eclipse.uml2.uml.UMLPackage
import org.eclipse.uml2.uml.resource.UMLResource
import tools.vitruv.framework.domains.AbstractVitruvDomain

class UmlDomain extends AbstractVitruvDomain {
	static final String METAMODEL_NAME = "UML";
	public static val NAMESPACE_URIS = UMLPackage.eINSTANCE.nsURIsRecursive;
	public static final String FILE_EXTENSION = UMLResource::FILE_EXTENSION;

	package new() {
		super(METAMODEL_NAME, UMLPackage.eINSTANCE, FILE_EXTENSION);
	}

}
