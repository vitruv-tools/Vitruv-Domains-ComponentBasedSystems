package tools.vitruv.domains.caex

class CAEXDomain {
	private val CAEXMetamodel caexMetamodel;
	
	public new() {
		caexMetamodel = new CAEXMetamodel();
	}
	
	// TODO HK Replace with generic type parameter when introducing parametrized super class
	def public CAEXMetamodel getMetamodel() {
		return caexMetamodel;
	}
}