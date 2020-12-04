package tools.vitruv.domains.emfprofiles

import tools.vitruv.framework.domains.VitruvDomainProvider

class EmfProfilesDomainProvider implements VitruvDomainProvider<EmfProfilesDomain> {
	static var EmfProfilesDomain instance;
	
	override EmfProfilesDomain getDomain() {
		if (instance === null) {
			instance = new EmfProfilesDomain();
		}
		return instance;
	}
}