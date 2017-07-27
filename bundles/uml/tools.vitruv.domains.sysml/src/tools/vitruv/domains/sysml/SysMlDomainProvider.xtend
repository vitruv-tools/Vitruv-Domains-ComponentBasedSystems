package tools.vitruv.domains.sysml

import tools.vitruv.framework.domains.VitruvDomainProvider

class SysMlDomainProvider implements VitruvDomainProvider<SysMlDomain> {
	private static var SysMlDomain instance;
	
	override public SysMlDomain getDomain() {
		if (instance === null) {
			instance = new SysMlDomain();
		}
		return instance;
	}
}