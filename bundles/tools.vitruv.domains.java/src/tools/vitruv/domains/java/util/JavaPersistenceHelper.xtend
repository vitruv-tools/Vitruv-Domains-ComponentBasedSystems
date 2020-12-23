package tools.vitruv.domains.java.util

import java.util.Arrays
import org.emftext.language.java.containers.CompilationUnit
import org.emftext.language.java.containers.Package

class JavaPersistenceHelper {

	static val UNNAMED_PACKAGE = "unnamedPackage"

	public static val PATH_SEPARATOR = "/"
	public static val FILE_EXTENSION_SEPARATOR = "."
	public static val JAVA_FILE_EXTENSION = "java"

	static def String getJavaProjectSrc() {
		return "src" + PATH_SEPARATOR;
	}

	static def String getPackageInfoClassName() {
		"package-info"
	}

	// Ensures that the source path is either empty or ends with '/'.
	private static def String normalizeSourcePath(String sourcePath) {
		if (sourcePath.nullOrEmpty) return ""
		if (sourcePath.endsWith(PATH_SEPARATOR)) {
			return sourcePath
		} else {
			return sourcePath + PATH_SEPARATOR
		}
	}

	static def stripJavaSourcePath(String javaFilePath, String sourcePath) {
		if (javaFilePath.nullOrEmpty) return javaFilePath // null -> null, '' -> ''

		// Get and return the path relative to the (normalized) source path:
		val normalizedSourcePath = sourcePath.normalizeSourcePath
		if (!normalizedSourcePath.empty && javaFilePath.startsWith(normalizedSourcePath)) {
			return javaFilePath.substring(normalizedSourcePath.length)
		} else {
			// Ensure that the returned path is relative:
			if (javaFilePath.startsWith(PATH_SEPARATOR)) {
				return javaFilePath.substring(PATH_SEPARATOR.length)
			} else {
				return javaFilePath
			}
		}
	}

	static def String buildJavaPath(String sourcePath, Iterable<String> namespaces) {
		return buildJavaFilePath(sourcePath, namespaces, "", "")
	}

	// fileExtension can be empty and is then omitted.
	static def String buildJavaFilePath(String sourcePath, Iterable<String> namespaces, String fileName,
		String fileExtension) {
		return '''«sourcePath.normalizeSourcePath»«
			FOR namespace : namespaces SEPARATOR PATH_SEPARATOR AFTER PATH_SEPARATOR»«namespace»«ENDFOR»«
			fileName»«
			IF !fileExtension.nullOrEmpty»«FILE_EXTENSION_SEPARATOR»«fileExtension»«ENDIF»'''
	}

	// Uses 'src/' as source path.
	// The fileName is simply appended to the end of the file path. It may or may not contain additional path segments
	// and may or may not include the file extension.
	static def String buildJavaFilePath(String fileName, Iterable<String> namespaces) {
		return buildJavaFilePath(javaProjectSrc, namespaces, fileName, null)
	}

	// Uses 'src/' as source path.
	// The compilation unit name is expected to already include the file extension.
	static def String buildJavaFilePath(CompilationUnit compilationUnit) {
		return buildJavaFilePath(compilationUnit.name, compilationUnit.namespaces)
	}

	// Uses 'src/' as source path.
	static def String buildJavaFilePath(Package javaPackage) {
		return buildJavaPackageFilePath(javaProjectSrc, javaPackage.namespaces, javaPackage.name)
	}

	static def String buildJavaPackageFilePath(String sourcePath, Iterable<String> namespaces,
		String packageName) {
		val fullNamespaces = getFullPackageNamespaces(namespaces, packageName)
		return buildJavaFilePath(sourcePath, fullNamespaces, packageInfoClassName, JAVA_FILE_EXTENSION)
	}

	static def String buildJavaPackagePath(String sourcePath, Iterable<String> namespaces,
		String packageName) {
		val fullNamespaces = getFullPackageNamespaces(namespaces, packageName)
		return buildJavaPath(sourcePath, fullNamespaces)
	}

	private static def getFullPackageNamespaces(Iterable<String> namespaces, String packageName) {
		return namespaces + Arrays.asList(packageName ?: UNNAMED_PACKAGE)
	}
}
