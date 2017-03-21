package tools.vitruv.domains.plcopen

import org.junit.Test
import org.junit.Assert
import org.plcopen.xml.tc60201.Tc60201Package
import org.plcopen.xml.tc60201.Tc60201Factory

class PLCOpenMetamodelTests {
	@Test
	public def void testTuidCalculator() {
		val o = Tc60201Factory.eINSTANCE.createAccessVariableType
		o.alias = "Test";
		val tuidFragments = new PLCOpenDomain().metamodel.calculateTuid(o).toString.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(Tc60201Package.eNS_URI, tuidFragments.get(0));
		Assert.assertEquals("alias" + "=" + o.alias, tuidFragments.get(2)); // FIXME MK PLCOpen obtain attribute name test from package
		Assert.assertNotNull(tuidFragments.get(1));
	}
	
}