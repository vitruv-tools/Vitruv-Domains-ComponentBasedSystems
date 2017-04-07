package tools.vitruv.domains.plcopen

import org.plcopen.xml.tc60201.Tc60201Package
import tools.vitruv.framework.metamodel.Metamodel
import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.framework.util.datatypes.VURI

class PLCOpenMetamodel extends Metamodel {
	public static val NAMESPACE_URIS = Tc60201Package.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "tc60201";

	package new() {
		super(VURI.getInstance(Tc60201Package.eNS_URI), NAMESPACE_URIS, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolver(Tc60201Package.eNS_URI, #["mixed", "documentation"]); // FIXME MK set PLCOpen name attributes!
	}

}
