package tools.vitruv.domains.uml

import org.eclipse.uml2.uml.UMLFactory
import org.eclipse.uml2.uml.UMLPackage
import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertTrue
import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertNotNull

class UmlDomainTests {
	@Test
	def void testTuidCalculator() {
		val clazz = UMLFactory.eINSTANCE.createClass();
		clazz.name = "Test";
		val tuidFragments = new UmlDomainProvider().domain.calculateTuid(clazz).toString.split("#");
		assertEquals(3, tuidFragments.length);
		assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		assertEquals("<root>-_-" + clazz.eClass.name + "-_-" + UMLPackage.Literals.NAMED_ELEMENT__NAME.name + "=" + clazz.name, tuidFragments.get(2));
		assertNotNull(tuidFragments.get(1));
	}
	
	@Test
	def void testGeneralizationTuidCalculation() {
		val superClass = UMLFactory.eINSTANCE.createClass();
		superClass.name = "Super";
		val subClass = UMLFactory.eINSTANCE.createClass();
		subClass.name = "Sub";
		val generalization = UMLFactory.eINSTANCE.createGeneralization();
		generalization.specific = subClass;
		generalization.general = superClass;
		val tuidFragments = new UmlDomainProvider().domain.calculateTuid(generalization).toString.split("#");
		assertEquals(4, tuidFragments.length);
		assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		assertEquals("generalization" + "-_-" + generalization.eClass.name + "-_-" + 
			"general" + "=" + superClass.name, 
			tuidFragments.get(3)
		);
		assertNotNull(tuidFragments.get(1));
	}
	
	@Test
	def void testGeneralizationGeneralOnlyTuidCalculation() {
		val superClass = UMLFactory.eINSTANCE.createClass();
		superClass.name = "Super";
		val generalization = UMLFactory.eINSTANCE.createGeneralization();
		generalization.general = superClass;
		val tuidFragments = new UmlDomainProvider().domain.calculateTuid(generalization).toString.split("#");
		assertEquals(3, tuidFragments.length);
		assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		assertEquals("<root>-_-" + generalization.eClass.name + "-_-" + 
			"general" + "=" + superClass.name, 
			tuidFragments.get(2)
		);
		assertNotNull(tuidFragments.get(1));
	}
	
	@Test
	def void testEmptyGeneralizationTuidCalculation() {
		val generalization = UMLFactory.eINSTANCE.createGeneralization();
		// No classifiers the generalization belongs to
		val tuidFragments = new UmlDomainProvider().domain.calculateTuid(generalization).toString.split("#");
		assertEquals(3, tuidFragments.length);
		assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		assertEquals("<root>-_-" + generalization.eClass.name + "-_-" + "general", 
			tuidFragments.get(2)
		);
		assertNotNull(tuidFragments.get(1));
	}
	
	@Test
	def void testEmptyPackageImportTuidCalculation() {
		val import = UMLFactory.eINSTANCE.createPackageImport();
		// No classifiers the generalization belongs to
		val tuidFragments = new UmlDomainProvider().domain.calculateTuid(import).toString.split("#");
		assertEquals(3, tuidFragments.length);
		assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		assertEquals("<root>-_-" + import.eClass.name + "-_-" + "package", 
			tuidFragments.get(2)
		);
		assertNotNull(tuidFragments.get(1));
	}
	
	@Test
	def void testPackageImportTuidCalculation() {
		val import = UMLFactory.eINSTANCE.createPackageImport();
		val pckg = UMLFactory.eINSTANCE.createPackage();
		pckg.name = "TestPackage";
		import.importedPackage = pckg;
		val tuidFragments = new UmlDomainProvider().domain.calculateTuid(import).toString.split("#");
		assertEquals(3, tuidFragments.length);
		assertEquals(UMLPackage.eNS_URI, tuidFragments.get(0));
		assertEquals("<root>" + "-_-" + import.eClass.name + "-_-" + 
			"package" + "=" + pckg.name, 
			tuidFragments.get(2)
		);
		assertNotNull(tuidFragments.get(1));
	}
}