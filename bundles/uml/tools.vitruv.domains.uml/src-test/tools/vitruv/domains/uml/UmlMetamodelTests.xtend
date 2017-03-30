package tools.vitruv.domains.uml

import org.junit.Test
import org.eclipse.uml2.uml.UMLFactory
import org.junit.Assert
import org.eclipse.uml2.uml.UMLPackage

class UmlMetamodelTests {
	@Test
	public def void testTuidCalculator() {
		val clazz = UMLFactory.eINSTANCE.createClass();
		clazz.name = "Test";
		val tuidFragments = new UmlDomain().metamodel.calculateTuid(clazz).toString.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		Assert.assertEquals("<root>-_-" + clazz.eClass.name + "-_-" + UMLPackage.Literals.NAMED_ELEMENT__NAME.name + "=" + clazz.name, tuidFragments.get(2));
		Assert.assertNotNull(tuidFragments.get(1));
	}
	
	@Test
	public def void testGeneralizationTuidCalculation() {
		val superClass = UMLFactory.eINSTANCE.createClass();
		superClass.name = "Super";
		val subClass = UMLFactory.eINSTANCE.createClass();
		subClass.name = "Sub";
		val generalization = UMLFactory.eINSTANCE.createGeneralization();
		generalization.specific = subClass;
		generalization.general = superClass;
		val tuidFragments = new UmlDomain().metamodel.calculateTuid(generalization).toString.split("#");
		Assert.assertEquals(4, tuidFragments.length);
		Assert.assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		Assert.assertEquals("generalization" + "-_-" + generalization.eClass.name + "-_-" + 
			"general" + "=" + superClass.name, 
			tuidFragments.get(3)
		);
		Assert.assertNotNull(tuidFragments.get(1));
	}
	
	@Test
	public def void testGeneralizationGeneralOnlyTuidCalculation() {
		val superClass = UMLFactory.eINSTANCE.createClass();
		superClass.name = "Super";
		val generalization = UMLFactory.eINSTANCE.createGeneralization();
		generalization.general = superClass;
		val tuidFragments = new UmlDomain().metamodel.calculateTuid(generalization).toString.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		Assert.assertEquals("<root>-_-" + generalization.eClass.name + "-_-" + 
			"general" + "=" + superClass.name, 
			tuidFragments.get(2)
		);
		Assert.assertNotNull(tuidFragments.get(1));
	}
	
	@Test
	public def void testEmptyGeneralizationTuidCalculation() {
		val generalization = UMLFactory.eINSTANCE.createGeneralization();
		// No classifiers the generalization belongs to
		val tuidFragments = new UmlDomain().metamodel.calculateTuid(generalization).toString.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		Assert.assertEquals("<root>-_-" + generalization.eClass.name + "-_-" + "general", 
			tuidFragments.get(2)
		);
		Assert.assertNotNull(tuidFragments.get(1));
	}
	
}