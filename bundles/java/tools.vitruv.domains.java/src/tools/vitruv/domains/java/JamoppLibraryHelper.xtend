package tools.vitruv.domains.java

import java.io.File
import org.emftext.language.java.JavaClasspath
import org.eclipse.emf.common.util.URI

/**
 * This helper class allows to load the Java standard library in JaMoPP also with
 * Java versions 9 and above.
 * In Java 9 the boot classpath was removed and the standard library is packaged
 * differently, which is corrected by this patch.
 * 
 * The code is partly adapted from org.emftext.language.java.JavaClasspath:
 * https://github.com/DevBoost/JaMoPP/blob/master/Core/org.emftext.language.java/src/org/emftext/language/java/JavaClasspath.java
 */
class JamoppLibraryHelper {
	public static def void registerStdLib() {
		val String javaVersion = System.getProperty("java.version");
		
		// Until Java 1.8 we can use the mechanism of JaMoPP
		if (javaVersion.startsWith("1.")) {
			JavaClasspath.get().registerStdLib();
		// From Java 9 on, we have to search for the correct class path and jar files
		} else {
			val String classpath = System.getProperty("java.class.path");
			val String[] classpathEntries = classpath.split(File.pathSeparator);

			val String rtJarSuffix = File.separator + "jrt-fs.jar";

			for (var idx = 0; idx < classpathEntries.length; idx++) {
				val String classpathEntry = classpathEntries.get(idx);
				if (classpathEntry.endsWith(rtJarSuffix)) {
					val URI uri = URI.createFileURI(classpathEntry);
					JavaClasspath.get().registerClassifierJar(uri);
				}
			}
		}
	}
}
