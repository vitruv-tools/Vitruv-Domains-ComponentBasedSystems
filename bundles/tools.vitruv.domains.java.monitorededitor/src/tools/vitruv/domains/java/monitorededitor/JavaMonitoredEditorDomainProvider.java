package tools.vitruv.domains.java.monitorededitor;

import tools.vitruv.framework.domains.VitruvDomainProvider;

public class JavaMonitoredEditorDomainProvider implements VitruvDomainProvider<JavaMonitoredEditorDomain> {
	private static JavaMonitoredEditorDomain instance;

	@Override
	public synchronized JavaMonitoredEditorDomain getDomain() {
		if (instance == null) {
			instance = new JavaMonitoredEditorDomain();
		}
		return instance;
	}
}
