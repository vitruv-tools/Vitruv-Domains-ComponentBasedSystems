package tools.vitruv.domains.caex

import org.junit.Test
import org.junit.Assert
import CAEX.CAEXFactory
import CAEX.CAEXPackage

class CAEXMetamodelTests {
	@Test
	public def void testTuidCalculator() {
		val o = CAEXFactory.eINSTANCE.createCAEXObject
		o.name = "Test";
		val tuidFragments = new CAEXDomain().metamodel.calculateTuid(o).toString.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(CAEXPackage.eNS_URI, tuidFragments.get(0));
		Assert.assertEquals(CAEXPackage.Literals.CAEX_OBJECT.name + "=" + o.name, tuidFragments.get(2));
		Assert.assertNotNull(tuidFragments.get(1));
	}
	
}