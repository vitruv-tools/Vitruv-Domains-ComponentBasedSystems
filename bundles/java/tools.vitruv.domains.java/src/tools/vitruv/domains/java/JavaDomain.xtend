package tools.vitruv.domains.java

import tools.vitruv.framework.vsum.domains.VitruvDomain

class JavaDomain implements VitruvDomain<JavaMetamodel> {
	private val JavaMetamodel javaMetamodel;
	
	public new() {
		javaMetamodel = new JavaMetamodel();
	}
	
	override public JavaMetamodel getMetamodel() {
		return javaMetamodel;
	}
}