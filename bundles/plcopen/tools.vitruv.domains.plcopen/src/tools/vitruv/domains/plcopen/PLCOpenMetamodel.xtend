package tools.vitruv.domains.plcopen

import org.plcopen.xml.tc60201.Tc60201Package
import tools.vitruv.framework.metamodel.Metamodel
import tools.vitruv.framework.tuid.AttributeTUIDCalculatorAndResolver
import tools.vitruv.framework.tuid.TUIDCalculatorAndResolver
import tools.vitruv.framework.util.datatypes.VURI

class PLCOpenMetamodel extends Metamodel {
	public static val NAMESPACE_URIS = Tc60201Package.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "xmi"; // FIXME MK set PLCOpen file extension!

	package new() {
		super(VURI.getInstance(Tc60201Package.eNS_URI), NAMESPACE_URIS, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TUIDCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTUIDCalculatorAndResolver(Tc60201Package.eNS_URI, #["alias"]); // FIXME MK set PLCOpen name attributes!
	}

}
