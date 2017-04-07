package tools.vitruv.domains.caex

import tools.vitruv.framework.metamodel.Metamodel
import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.framework.util.datatypes.VURI
import CAEX.CAEXPackage

class CAEXMetamodel extends Metamodel {
	public static val NAMESPACE_URIS = CAEXPackage.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "caex";

	package new() {
		super(VURI.getInstance(CAEXPackage.eNS_URI), NAMESPACE_URIS, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolver(CAEXPackage.eNS_URI, #["xMLNSPrefixMap", "fileName", CAEXPackage.Literals.CAEX_OBJECT.getName()]);
	}

}
