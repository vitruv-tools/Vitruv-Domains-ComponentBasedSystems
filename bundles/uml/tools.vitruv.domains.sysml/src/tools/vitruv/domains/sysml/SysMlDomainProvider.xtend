package tools.vitruv.domains.sysml

import tools.vitruv.framework.domains.VitruvDomainProvider

class SysMlDomainProvider implements VitruvDomainProvider<SysMlDomain> {
	static var SysMlDomain instance;
	
	override SysMlDomain getDomain() {
		if (instance === null) {
			instance = new SysMlDomain();
		}
		return instance;
	}
}