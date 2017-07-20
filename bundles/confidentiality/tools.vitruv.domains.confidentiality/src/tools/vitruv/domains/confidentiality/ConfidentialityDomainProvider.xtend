package tools.vitruv.domains.confidentiality

import tools.vitruv.framework.domains.VitruvDomainProvider

class ConfidentialityDomainProvider implements VitruvDomainProvider<ConfidentialityDomain> {
	private static var ConfidentialityDomain instance;
	
	override public ConfidentialityDomain getDomain() {
		if (instance == null) {
			instance = new ConfidentialityDomain();
		}
		return instance;
	}
}