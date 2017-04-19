package tools.vitruv.domains.java

import tools.vitruv.domains.java.tuid.JavaTuidCalculatorAndResolver
import static tools.vitruv.domains.java.JavaNamespace.*
import tools.vitruv.framework.domains.AbstractVitruvDomain

final class JavaDomain extends AbstractVitruvDomain {
	private static final String METAMODEL_NAME = "Java";
	
	package new() {
		super(METAMODEL_NAME, ROOT_PACKAGE, generateTuidCalculator(), #[FILE_EXTENSION]);
	}
	
	def protected static generateTuidCalculator() {
		return new JavaTuidCalculatorAndResolver();
	}
	
}