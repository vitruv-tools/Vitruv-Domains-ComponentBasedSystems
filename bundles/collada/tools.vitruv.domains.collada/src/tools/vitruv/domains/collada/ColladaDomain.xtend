package tools.vitruv.domains.collada

import tools.vitruv.domains.collada.tuid.AttributeTuidCalculatorAndResolverSpecificRoot
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator
import org.khronos.collada.ColladaPackage
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain

class ColladaDomain extends AbstractTuidAwareVitruvDomain {
	public static final String METAMODEL_NAME = "Collada"
	public static val NAMESPACE_URIS = ColladaPackage.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "aml";

	package new() {
		super(METAMODEL_NAME, ColladaPackage.eINSTANCE, generateTuidCalculator(), FILE_EXTENSION);
	}

	//TODO
	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolverSpecificRoot(ColladaPackage.eNS_URI, #["name","iD", "value", "fileName", "originID", "alias", ColladaPackage.eINSTANCE.getCOLLADAType.name/*ColladaPackage.Literals.COLLADAType.name*/], #["xMLNSPrefixMap"]);
	}

	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}	
}
