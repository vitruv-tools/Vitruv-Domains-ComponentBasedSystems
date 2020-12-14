package tools.vitruv.domains.java.builder;

import org.apache.log4j.Logger;
import org.eclipse.ui.IStartup;

import tools.vitruv.framework.ui.monitorededitor.ProjectBuildUtils;

/**
 * {@link JavaBuildOnEclipseStartup} issues an incremental build of all open
 * projects just after Eclipse started. This ensures that the respective builder
 * objects do exist (and install EMF editor monitors) before the user starts
 * editing files.
 */
public class JavaBuildOnEclipseStartup implements IStartup {
	private static final Logger LOGGER = Logger.getLogger(JavaBuildOnEclipseStartup.class);

	@Override
	public void earlyStartup() {
		try {
			ProjectBuildUtils.issueIncrementalBuildForAllProjectsWithBuilder(VitruviusJavaBuilder.BUILDER_ID);
		} catch (IllegalStateException e) {
			LOGGER.error("Could not issue initial build for all projects", e);
		}
	}
}
