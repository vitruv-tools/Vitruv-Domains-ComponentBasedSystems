package tools.vitruv.domains.java.builder;

import java.util.Map;

import org.apache.log4j.Logger;
import org.eclipse.core.resources.ICommand;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;

import tools.vitruv.domains.java.monitorededitor.MonitoredEditor;
import tools.vitruv.framework.ui.monitorededitor.VitruviusProjectBuilder;

public class VitruviusJavaBuilder extends VitruviusProjectBuilder {
	// ID of JavaBuilder
	public static final String BUILDER_ID = "tools.vitruv.domains.java.builder.JavaBuilder.id";

	private static Logger logger = Logger.getLogger(VitruviusJavaBuilder.class);

	public VitruviusJavaBuilder() {
		super();
	}

	@Override
	protected IProject[] build(final int kind, final Map<String, String> args, final IProgressMonitor monitor)
			throws CoreException {
		return super.build(kind, args, monitor);
	}

	@Override
	protected void startMonitoring() {
		String monitoredProjectName = getProject().getName();
		logger.info("Start monitoring with Vitruv Java builder for project " + monitoredProjectName);

		MonitoredEditor monitoredEditor = new MonitoredEditor(this.getVirtualModel(), this::isStillRegistered,
				monitoredProjectName);
		monitoredEditor.startMonitoring();
		logger.info("Started monitoring with Vitruv Java builder for project " + monitoredProjectName);
	}

	private boolean isStillRegistered() {
		try {
			for (ICommand buildSpec : getProject().getDescription().getBuildSpec()) {
				if (BUILDER_ID.equals(buildSpec.getBuilderName())) {
					return true;
				}
			}
		} catch (CoreException e) {
			String message = "Cannot read build specification for project: " + getProject().getName();
			logger.error(message, e);
			throw new IllegalStateException(message, e);
		}
		return false;
	}
}
