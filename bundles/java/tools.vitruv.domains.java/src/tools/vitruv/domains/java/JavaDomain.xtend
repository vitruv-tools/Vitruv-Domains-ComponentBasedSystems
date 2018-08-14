package tools.vitruv.domains.java

import tools.vitruv.domains.java.tuid.JavaTuidCalculatorAndResolver
import static tools.vitruv.domains.java.JavaNamespace.*
import tools.vitruv.domains.java.builder.VitruviusJavaBuilderApplicator
import org.emftext.language.java.JavaClasspath
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain

final class JavaDomain extends AbstractTuidAwareVitruvDomain {
	private static final String METAMODEL_NAME = "Java";
	private boolean shouldTransitivelyPropagateChanges = false;
		
	package new() {
		super(METAMODEL_NAME, ROOT_PACKAGE, generateTuidCalculator(), #[FILE_EXTENSION]);
		// This is necessary to resolve classes from standard library (e.g. Object, List etc.) 
		// when running as Plugin
		JavaClasspath.get().registerStdLib
	}
	
	def protected static generateTuidCalculator() {
		return new JavaTuidCalculatorAndResolver();
	}
	
	override getBuilderApplicator() {
		return new VitruviusJavaBuilderApplicator();
	}
	
	override shouldTransitivelyPropagateChanges() {
		return shouldTransitivelyPropagateChanges;
	}
	
	/**
	 * Calling this methods enable the per default disabled transitive change propagation.
	 * Should only be called for test purposes!
	 */
	public def enableTransitiveChangePropagation() {
		shouldTransitivelyPropagateChanges = true
	}
	
}