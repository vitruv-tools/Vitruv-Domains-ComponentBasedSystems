package tools.vitruv.domains.caex

import tools.vitruv.domains.caex.tuid.AttributeTuidCalculatorAndResolverSpecificRoot
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator
import caex.caex30.caex.CAEXPackage
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain

class CAEXDomain extends AbstractTuidAwareVitruvDomain {
	public static final String METAMODEL_NAME = "CAEX"
	public static val NAMESPACE_URIS = CAEXPackage.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "caex";

	package new() {
		super(METAMODEL_NAME, CAEXPackage.eINSTANCE, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolverSpecificRoot(CAEXPackage.eNS_URI, #["name","iD", "value", "fileName", "originID", "alias", CAEXPackage.Literals.CAEX_OBJECT.getName()], #["xMLNSPrefixMap"]);
	}

	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}	
}
