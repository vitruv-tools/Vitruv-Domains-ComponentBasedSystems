package tools.vitruv.domains.caex

import org.junit.Test
import org.junit.Assert
import org.automationml.caex.caex.CaexFactory
import org.automationml.caex.caex.CaexPackage

class CAEXDomainTests {
	@Test
	public def void testTuidCalculator() {
		val o = CaexFactory.eINSTANCE.createCAEXObject
		o.name = "Test";
		val tuidFragments = new CAEXDomainProvider().domain.calculateTuid(o).toString.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(CaexPackage.eNS_URI, tuidFragments.get(0));
		Assert.assertEquals(CaexPackage.Literals.CAEX_OBJECT.name + "=" + o.name, tuidFragments.get(2));
		Assert.assertNotNull(tuidFragments.get(1));
	}
	
}