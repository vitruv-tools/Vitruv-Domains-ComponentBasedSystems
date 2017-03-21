package tools.vitruv.domains.caex

import tools.vitruv.framework.metamodel.Metamodel
import tools.vitruv.framework.tuid.AttributeTUIDCalculatorAndResolver
import tools.vitruv.framework.tuid.TUIDCalculatorAndResolver
import tools.vitruv.framework.util.datatypes.VURI
import CAEX.CAEXPackage

class CAEXMetamodel extends Metamodel {
	public static val NAMESPACE_URIS = CAEXPackage.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "aml";

	package new() {
		super(VURI.getInstance(CAEXPackage.eNS_URI), NAMESPACE_URIS, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TUIDCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTUIDCalculatorAndResolver(CAEXPackage.eNS_URI, #[CAEXPackage.Literals.CAEX_OBJECT.getName()]);
	}

}
