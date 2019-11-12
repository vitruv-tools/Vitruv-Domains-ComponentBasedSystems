package tools.vitruv.domains.java

import tools.vitruv.domains.java.tuid.JavaTuidCalculatorAndResolver
import static tools.vitruv.domains.java.JavaNamespace.*
import tools.vitruv.domains.java.builder.VitruviusJavaBuilderApplicator
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain
import org.eclipse.emf.ecore.resource.Resource
import org.emftext.language.java.resource.JavaSourceOrClassFileResourceFactoryImpl

final class JavaDomain extends AbstractTuidAwareVitruvDomain {
	private static final String METAMODEL_NAME = "Java";
	private boolean shouldTransitivelyPropagateChanges = false;
		
	package new() {
		super(METAMODEL_NAME, ROOT_PACKAGE, generateTuidCalculator(), #[FILE_EXTENSION]);
		// Register factory for class and Java files in case of not running as plugin
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("java", new JavaSourceOrClassFileResourceFactoryImpl());
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("class", new JavaSourceOrClassFileResourceFactoryImpl());
		// This is necessary to resolve classes from standard library (e.g. Object, List etc.) 
		JamoppLibraryHelper.registerStdLib
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
	
	override supportsUuids() {
		return false;
	}

}