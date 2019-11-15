package tools.vitruv.domains.java

import org.emftext.language.java.JavaClasspath
import org.emftext.language.java.JavaClasspath.Initializer
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.common.util.URI

/**
 * This helper class allows to load the Java standard library in JaMoPP also with
 * Java versions 9 and above.
 * In Java 9 the boot classpath was removed and the standard library is packaged
 * differently, which is corrected by this patch.
 */
class JamoppLibraryHelper {
	public static String STANDARD_LIBRARY_PATH_IN_HOME = "/jmods/java.base.jmod";
	
	public static def void registerStdLib() {
		val String javaVersion = System.getProperty("java.version");
		
		// Until Java 1.8 we can use the mechanism of JaMoPP
		if (javaVersion.startsWith("1.")) {
			JavaClasspath.get().registerStdLib();
		// From Java 9 on, we have to search for the Java base module instead of the rt.jar file.
		// To do so, we disable automatic initialization of the standard library using the classpath 
		// (where library cannot be found in Java 9 and above) and manually load the base Java module
		} else {
			JavaClasspath.initializers.add(new Initializer() {
				override initialize(Resource resource) {}
				override requiresLocalClasspath() { false }
				override requiresStdLib() { false }
			})
			val String classpath = System.getProperty("java.home") + STANDARD_LIBRARY_PATH_IN_HOME;
			val uri = URI.createFileURI(classpath);
			// From java 9, the module files do not directly contain the classes in the package structure
			// but are placed in the "classes" folder, so that prefix has to be removed.
			JavaClasspath.get().registerClassifierJar(uri, "classes/");
		}
	}

}
