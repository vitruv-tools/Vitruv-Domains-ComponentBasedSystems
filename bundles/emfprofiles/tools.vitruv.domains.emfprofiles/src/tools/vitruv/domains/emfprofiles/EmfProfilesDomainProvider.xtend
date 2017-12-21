package tools.vitruv.domains.emfprofiles

import tools.vitruv.framework.domains.VitruvDomainProvider

class EmfProfilesDomainProvider implements VitruvDomainProvider<EmfProfilesDomain> {
	private static var EmfProfilesDomain instance;
	
	override public EmfProfilesDomain getDomain() {
		if (instance === null) {
			instance = new EmfProfilesDomain();
		}
		return instance;
	}
}