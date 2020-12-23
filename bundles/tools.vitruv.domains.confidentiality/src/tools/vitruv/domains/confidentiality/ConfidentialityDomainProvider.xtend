package tools.vitruv.domains.confidentiality

import tools.vitruv.framework.domains.VitruvDomainProvider

class ConfidentialityDomainProvider implements VitruvDomainProvider<ConfidentialityDomain> {
	static var ConfidentialityDomain instance;
	
	override ConfidentialityDomain getDomain() {
		if (instance === null) {
			instance = new ConfidentialityDomain();
		}
		return instance;
	}
}