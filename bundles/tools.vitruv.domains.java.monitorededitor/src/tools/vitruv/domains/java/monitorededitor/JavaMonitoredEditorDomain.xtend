package tools.vitruv.domains.java.monitorededitor

import tools.vitruv.domains.java.builder.VitruviusJavaBuilderApplicator
import tools.vitruv.domains.java.JavaDomain

final class JavaMonitoredEditorDomain extends JavaDomain {
	package new() {
		super("Java Monitored Editor")
	}
	
	override getBuilderApplicator() {
		return new VitruviusJavaBuilderApplicator();
	}
}