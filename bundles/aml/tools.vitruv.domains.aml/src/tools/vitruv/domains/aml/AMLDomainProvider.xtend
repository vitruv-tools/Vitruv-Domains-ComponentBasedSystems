package tools.vitruv.domains.aml

import tools.vitruv.framework.domains.VitruvDomainProvider

class AMLDomainProvider implements VitruvDomainProvider<AMLDomain> {
	private static var AMLDomain instance;
	
	override public AMLDomain getDomain() {
		if (instance === null) {
			instance = new AMLDomain();
		}
		return instance;
	}
}