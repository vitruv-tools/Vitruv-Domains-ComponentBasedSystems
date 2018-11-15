package tools.vitruv.domains.aml

import tools.vitruv.domains.aml.tuid.AttributeTuidCalculatorAndResolverSpecificRoot
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator
import edu.kit.sdq.aml_aggregator.Aml_aggregatorPackage
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain

class AMLDomain extends AbstractTuidAwareVitruvDomain {
	public static final String METAMODEL_NAME = "AML"
	public static val NAMESPACE_URIS = Aml_aggregatorPackage.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "aml_aggregator";

	package new() {
		super(METAMODEL_NAME, Aml_aggregatorPackage.eINSTANCE, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolverSpecificRoot(Aml_aggregatorPackage.eNS_URI, #["name", "path", Aml_aggregatorPackage.Literals.AML_PROJECT.name], #["xMLNSPrefixMap"]);
	}

	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}	
}
