package tools.vitruv.domains.caex

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import CAEX.CAEXPackage
import tools.vitruv.framework.domains.AbstractVitruvDomain

class CAEXDomain extends AbstractVitruvDomain {
	public static final String METAMODEL_NAME = "CAEX"
	public static val NAMESPACE_URIS = CAEXPackage.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "caex";

	package new() {
		super(METAMODEL_NAME, CAEXPackage.eINSTANCE, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolver(CAEXPackage.eNS_URI, #["xMLNSPrefixMap", "fileName", CAEXPackage.Literals.CAEX_OBJECT.getName()]);
	}

}
