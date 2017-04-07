package tools.vitruv.domains.uml

import org.eclipse.uml2.uml.UMLPackage
import org.eclipse.uml2.uml.resource.UMLResource
import tools.vitruv.framework.metamodel.Metamodel
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.framework.util.datatypes.VURI
import tools.vitruv.domains.uml.tuid.UmlTuidCalculatorAndResolver

class UmlMetamodel extends Metamodel {
	public static val NAMESPACE_URIS = UMLPackage.eINSTANCE.nsURIsRecursive;
	public static final String FILE_EXTENSION = UMLResource::FILE_EXTENSION;

	package new() {
		super(VURI.getInstance(UMLPackage.eNS_URI), NAMESPACE_URIS, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new UmlTuidCalculatorAndResolver(UMLPackage.eNS_URI);
	}

}
