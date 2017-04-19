package tools.vitruv.domains.plcopen

import tools.vitruv.framework.domains.VitruvDomainProvider

class PLCOpenDomainProvider implements VitruvDomainProvider<PLCOpenDomain> {
	private static var PLCOpenDomain instance;
	
	override public PLCOpenDomain getDomain() {
		if (instance == null) {
			instance = new PLCOpenDomain();
		}
		return instance;
	}
}