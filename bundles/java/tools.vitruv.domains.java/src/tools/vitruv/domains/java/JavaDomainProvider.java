package tools.vitruv.domains.java;

import tools.vitruv.framework.domains.VitruvDomainProvider;

public class JavaDomainProvider implements VitruvDomainProvider<JavaDomain> {
	private static JavaDomain instance;
	
	@Override
	public synchronized JavaDomain getDomain() {
		if (instance == null) {
			instance = new JavaDomain();
		}
		return instance;
	}
}
