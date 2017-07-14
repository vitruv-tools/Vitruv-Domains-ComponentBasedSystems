package tools.vitruv.domains.uml

import org.eclipse.uml2.uml.UMLPackage
import org.eclipse.uml2.uml.resource.UMLResource
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.domains.uml.tuid.UmlTuidCalculatorAndResolver
import tools.vitruv.framework.domains.AbstractVitruvDomain
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator

class UmlDomain extends AbstractVitruvDomain {
	private static final String METAMODEL_NAME = "UML";
	public static val NAMESPACE_URIS = UMLPackage.eINSTANCE.nsURIsRecursive;
	public static final String FILE_EXTENSION = UMLResource::FILE_EXTENSION;

	package new() {
		super(METAMODEL_NAME, UMLPackage.eINSTANCE, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new UmlTuidCalculatorAndResolver(UMLPackage.eNS_URI);
	}

	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}
	
}
