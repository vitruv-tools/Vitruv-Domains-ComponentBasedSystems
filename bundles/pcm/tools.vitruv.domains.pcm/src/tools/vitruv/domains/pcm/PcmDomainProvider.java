package tools.vitruv.domains.pcm;

import tools.vitruv.framework.domains.VitruvDomainProvider;

public class PcmDomainProvider implements VitruvDomainProvider<PcmDomain> {
	private static PcmDomain instance;
	
	@Override
	public synchronized PcmDomain getDomain() {
		if (instance == null) {
			instance = new PcmDomain();
		}
		return instance;
	}
}
