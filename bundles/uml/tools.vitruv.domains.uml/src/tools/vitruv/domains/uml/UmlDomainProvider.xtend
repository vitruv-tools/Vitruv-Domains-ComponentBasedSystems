package tools.vitruv.domains.uml

import tools.vitruv.framework.domains.VitruvDomainProvider

class UmlDomainProvider implements VitruvDomainProvider<UmlDomain> {
	static var UmlDomain instance;
	
	override getDomain() {
		if (instance === null) {
			instance = new UmlDomain();
		}
		return instance;
	}
	
}