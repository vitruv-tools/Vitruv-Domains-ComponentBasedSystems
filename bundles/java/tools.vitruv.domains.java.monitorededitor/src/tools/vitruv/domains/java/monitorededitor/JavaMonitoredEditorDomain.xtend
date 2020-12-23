package tools.vitruv.domains.java.monitorededitor

import tools.vitruv.domains.java.builder.VitruviusJavaBuilderApplicator
import tools.vitruv.domains.java.JavaDomain

final class JavaMonitoredEditorDomain extends JavaDomain {
	override getBuilderApplicator() {
		return new VitruviusJavaBuilderApplicator();
	}
}