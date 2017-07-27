package tools.vitruv.domains.caex

import tools.vitruv.framework.domains.VitruvDomainProvider

class CAEXDomainProvider implements VitruvDomainProvider<CAEXDomain> {
	private static var CAEXDomain instance;
	
	override public CAEXDomain getDomain() {
		if (instance === null) {
			instance = new CAEXDomain();
		}
		return instance;
	}
}