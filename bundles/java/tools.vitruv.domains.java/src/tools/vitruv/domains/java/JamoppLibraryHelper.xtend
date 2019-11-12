package tools.vitruv.domains.java

import java.io.File
import org.emftext.language.java.JavaClasspath
import org.emftext.language.java.JavaClasspath.Initializer
import org.eclipse.emf.ecore.resource.Resource
import tools.vitruv.framework.util.bridges.EMFBridge

/**
 * This helper class allows to load the Java standard library in JaMoPP also with
 * Java versions 9 and above.
 * In Java 9 the boot classpath was removed and the standard library is packaged
 * differently, which is corrected by this patch.
 */
class JamoppLibraryHelper {
	public static def void registerStdLib() {
		// Disable automatic initialization of standard library using the classpath (where library cannot be 
		// found in Java 9 and above
		JavaClasspath.initializers.add(new Initializer() {
			override initialize(Resource resource) {}
			override requiresLocalClasspath() { false }
			override requiresStdLib() { false }
		})
		
		// We place the Java 8 standard library in the res folder, in the target binaries it is placed 
		// in the root folder and in the Maven build target it is placed in the classes folder. 
		// We resolve it relative to the class file placement.
		var file = resolveLocalPath("rt.jar");
		if (!file.exists) {
			file = resolveLocalPath("classes/rt.jar");
		}
		if (!file.exists) {
			file = resolveLocalPath("res/rt.jar");
		}
		if (!file.exists) {
			throw new IllegalStateException("The Java standard class library cannot be found at: " + file.toString());
		}
		val uri = EMFBridge.getEmfFileUriForFile(file);
		JavaClasspath.get().registerClassifierJar(uri);
	}

	private static def File resolveLocalPath(String localPath) {
		new File(JamoppLibraryHelper.getProtectionDomain().getCodeSource().getLocation().toURI().resolve(localPath));	
	}

}
