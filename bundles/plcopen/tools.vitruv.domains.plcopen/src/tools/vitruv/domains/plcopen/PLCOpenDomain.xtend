package tools.vitruv.domains.plcopen

class PLCOpenDomain {
	private val PLCOpenMetamodel plcOpenMetamodel;
	
	public new() {
		plcOpenMetamodel = new PLCOpenMetamodel();
	}
	
	// TODO HK Replace with generic type parameter when introducing parametrized super class
	def public PLCOpenMetamodel getMetamodel() {
		return plcOpenMetamodel;
	}
}