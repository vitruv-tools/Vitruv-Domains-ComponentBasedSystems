package tools.vitruv.domains.collada

import tools.vitruv.framework.domains.VitruvDomainProvider

class ColladaDomainProvider implements VitruvDomainProvider<ColladaDomain> {
	private static var ColladaDomain instance;
	
	override public ColladaDomain getDomain() {
		if (instance === null) {
			instance = new ColladaDomain();
		}
		return instance;
	}
}