package tools.vitruv.domains.java

import static tools.vitruv.domains.java.JavaNamespace.*
import java.util.List
import tools.vitruv.framework.domains.AbstractVitruvDomain

class JavaDomain extends AbstractVitruvDomain {
	static final String METAMODEL_NAME = "Java"
	
	protected new() {
		this(METAMODEL_NAME)
	}
	
	protected new(String name) {
		super(name, ROOT_PACKAGE, List.of(FILE_EXTENSION))
	}

}