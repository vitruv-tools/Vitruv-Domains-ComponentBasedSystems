package tools.vitruv.domains.java

import static tools.vitruv.domains.java.JavaNamespace.*
import org.eclipse.emf.ecore.resource.Resource
import org.emftext.language.java.resource.JavaSourceOrClassFileResourceFactoryImpl
import java.util.Map
import org.emftext.language.java.resource.java.IJavaOptions
import java.util.List
import tools.vitruv.framework.domains.AbstractVitruvDomain

class JavaDomain extends AbstractVitruvDomain {
	static final String METAMODEL_NAME = "Java"
	boolean shouldTransitivelyPropagateChanges = false
	
	protected new() {
		this(METAMODEL_NAME)
	}
	
	protected new(String name) {
		super(name, ROOT_PACKAGE, List.of(FILE_EXTENSION))
		// Register factory for class and Java files in case of not running as plugin
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("java", new JavaSourceOrClassFileResourceFactoryImpl())
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("class", new JavaSourceOrClassFileResourceFactoryImpl())
		// This is necessary to resolve classes from standard library (e.g. Object, List etc.) 
		JamoppLibraryHelper.registerStdLib
	}
	
	override shouldTransitivelyPropagateChanges() {
		shouldTransitivelyPropagateChanges
	}
	
	/**
	 * Calling this method enables the per default disabled transitive change propagation.
	 * Should only be called for test purposes!
	 */
	def enableTransitiveChangePropagation() {
		shouldTransitivelyPropagateChanges = true
	}

	/**
	 * Calling this method disables the transitive change propagation which may have been
	 * enabled calling {@link #enableTransitiveChangePropagation()}.
	 * Should only be called for test purposes!
	 */
	def disableTransitiveChangePropagation() {
		shouldTransitivelyPropagateChanges = false
	}
	
}