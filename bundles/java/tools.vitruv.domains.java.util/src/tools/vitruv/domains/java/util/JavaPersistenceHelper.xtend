package tools.vitruv.domains.java.util

import org.emftext.language.java.containers.CompilationUnit

class JavaPersistenceHelper {
	private static val UNNAMED = "unnamedPackage"
	
	public static def String getJavaProjectSrc() {
		return "src/";
	}

	public static def String getPackageInfoClassName() {
		"package-info"
	}

	public static def String buildJavaFilePath(String fileName, String... namespaces) {
		return '''src/«FOR namespace : namespaces SEPARATOR "/" AFTER "/"»«namespace»«ENDFOR»«fileName»''';
	}

	public static def String buildJavaFilePath(CompilationUnit compilationUnit) {
		return '''src/«FOR namespace : compilationUnit.namespaces SEPARATOR "/" AFTER "/"»«namespace»«ENDFOR»«compilationUnit.name»''';
	}

	public static def String buildJavaFilePath(org.emftext.language.java.containers.Package javaPackage) {
		return '''src/«FOR namespace : javaPackage.namespaces SEPARATOR "/" AFTER "/"»«namespace»«ENDFOR»«javaPackage.name ?: UNNAMED»/«packageInfoClassName».java''';
	}
}
