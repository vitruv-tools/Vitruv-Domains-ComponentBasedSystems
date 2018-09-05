package tools.vitruv.domains.aml

import tools.vitruv.domains.aml.tuid.AttributeTuidCalculatorAndResolverSpecificRoot
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator
import aml.AmlPackage
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain

class AMLDomain extends AbstractTuidAwareVitruvDomain {
	public static final String METAMODEL_NAME = "AML"
	public static val NAMESPACE_URIS = AmlPackage.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "aml";

	package new() {
		super(METAMODEL_NAME, AmlPackage.eINSTANCE, generateTuidCalculator(), FILE_EXTENSION);
	}

	//TODO
	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolverSpecificRoot(AmlPackage.eNS_URI, #["name","iD", "value", "fileName", "originID", "alias", AmlPackage.Literals.AML_ROOT.name], #["xMLNSPrefixMap"]);
	}

	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}	
}
