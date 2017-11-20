package tools.vitruv.domains.plcopen

import org.plcopen.xml.tc60201.Tc60201Package
import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.framework.domains.AbstractVitruvDomain
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator

class PLCOpenDomain extends AbstractVitruvDomain {
	public static final String METAMODEL_NAME = "PLCOpen"
	public static val NAMESPACE_URIS = Tc60201Package.eINSTANCE.nsURIsRecursive
	public static final String FILE_EXTENSION = "tc60201";

	package new() {
		super(METAMODEL_NAME, Tc60201Package.eINSTANCE, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolver(Tc60201Package.eNS_URI, #["mixed", "documentation", "productVersion", "name"]); // FIXME MK set PLCOpen name attributes!
	}

	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}
	
}
