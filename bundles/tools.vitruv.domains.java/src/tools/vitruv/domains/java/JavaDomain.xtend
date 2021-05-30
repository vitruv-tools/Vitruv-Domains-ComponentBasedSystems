package tools.vitruv.domains.java

import static tools.vitruv.domains.java.JavaNamespace.*
import org.eclipse.emf.ecore.resource.Resource
import jamopp.resource.JavaResource2Factory
import java.util.List
import tools.vitruv.framework.domains.AbstractVitruvDomain
import org.emftext.language.java.JavaClasspath

class JavaDomain extends AbstractVitruvDomain {
	static final String METAMODEL_NAME = "Java"
	boolean shouldTransitivelyPropagateChanges = false
	
	protected new() {
		this(METAMODEL_NAME)
	}
	
	protected new(String name) {
		super(name, ROOT_PACKAGE, List.of(FILE_EXTENSION))
		// Register factory for class and Java files in case of not running as plugin
		val factory = new JavaResource2Factory
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("java", factory)
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("class", factory)
		JavaClasspath.get.registerStdLib
	}
	
	override shouldTransitivelyPropagateChanges() {
		shouldTransitivelyPropagateChanges
	}
	
	/**
	 * Calling this methods enable the per default disabled transitive change propagation.
	 * Should only be called for test purposes!
	 */
	def enableTransitiveChangePropagation() {
		shouldTransitivelyPropagateChanges = true
	}
}