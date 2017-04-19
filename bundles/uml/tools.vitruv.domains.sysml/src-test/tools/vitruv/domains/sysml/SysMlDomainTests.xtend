package tools.vitruv.domains.sysml

import org.junit.Test
import org.eclipse.uml2.uml.UMLFactory
import org.junit.Assert
import org.eclipse.emf.ecore.EObject
import org.eclipse.uml2.uml.UMLPackage
import org.eclipse.papyrus.sysml14.blocks.BlocksFactory
import org.eclipse.papyrus.sysml14.blocks.Block
import tools.vitruv.framework.tuid.Tuid
import tools.vitruv.framework.tuid.TuidManager
import tools.vitruv.framework.tuid.TuidUpdateListener
import java.util.ArrayList
import java.util.List
import org.junit.Before

class SysMlDomainTests {
	private static val TEST_CLASS_NAME = "Test";
	private var SysMlDomain sysMlDomain;
	
	@Before
	public def void setup() {
		TuidManager.instance.reinitialize
		sysMlDomain = new SysMlDomainProvider().domain;
	}
	
	@Test
	public def void testTuidCalculationForUmlElemente() {
		val clazz = UMLFactory.eINSTANCE.createClass();
		clazz.name = TEST_CLASS_NAME;
		testTuid(clazz, "Class", TEST_CLASS_NAME);
		val port = UMLFactory.eINSTANCE.createPort();
		port.name = TEST_CLASS_NAME;
		testTuid(port, "Port", TEST_CLASS_NAME);
	}
	
	@Test
	public def void testTuidCalculationForSysMlElements() {
		val block = createBlock();
		testTuid(block, "Class", TEST_CLASS_NAME);
		Assert.assertEquals(sysMlDomain.calculateTuid(block), sysMlDomain.calculateTuid(block.base_Class));
	}
	
	@Test
	public def void testResponsibilityChecks() {
		val block = createBlock();
		Assert.assertTrue(sysMlDomain.isInstanceOfDomainMetamodel(block));
		Assert.assertTrue(sysMlDomain.isInstanceOfDomainMetamodel(block.base_Class));
		Assert.assertTrue(sysMlDomain.calculateTuid(block) != null);
		Assert.assertTrue(sysMlDomain.calculateTuid(block.base_Class) != null);
	}
	
	@Test
	public def void testTuidUpdate() {
		val List<String> tuids = new ArrayList<String>();
		val dummyTuidUpdateListener = new TuidUpdateListener() {
			override performPreAction(Tuid oldTuid) {
				tuids.add(oldTuid.toString);
			}
			
			override performPostAction(Tuid newTuid) {
				tuids.add(newTuid.toString);
			}
		}
		TuidManager.instance.addTuidUpdateListener(dummyTuidUpdateListener);
		val block = createBlock();
		block.base_Class.name = "old";
		TuidManager.instance.registerObjectUnderModification(block);
		block.base_Class.name = "new";
		TuidManager.instance.updateTuidsOfRegisteredObjects();
		TuidManager.instance.flushRegisteredObjectsUnderModification();
		Assert.assertEquals(2, tuids.size);
		testTuid(tuids.get(0), "Class", "old");
		testTuid(tuids.get(1), "Class", "new");
	}
	
	private def Block createBlock() {
		val clazz = UMLFactory.eINSTANCE.createClass();
		clazz.name = TEST_CLASS_NAME;
		val block = BlocksFactory.eINSTANCE.createBlock();
		block.base_Class = clazz;
		return block;
	}
	
	private def void testTuid(EObject object, String expectedTypeName, String expectedName) {
		assertTuid(object, UMLPackage.eNS_URI, "<root>-_-" + expectedTypeName + "-_-" + UMLPackage.Literals.NAMED_ELEMENT__NAME.name + "=" + expectedName);
	}
	
	private def void testTuid(String tuid, String expectedTypeName, String expectedName) {
		assertTuid(tuid, UMLPackage.eNS_URI, "<root>-_-" + expectedTypeName + "-_-" + UMLPackage.Literals.NAMED_ELEMENT__NAME.name + "=" + expectedName);
	}
	
	private def void assertTuid(EObject object, String expectedNamespaceUri, String expectedIdentifier) {
		val tuid = sysMlDomain.calculateTuid(object).toString;
		assertTuid(tuid, expectedNamespaceUri, expectedIdentifier);
	}
	
	private def void assertTuid(String tuid, String expectedNamespaceUri, String expectedIdentifier) {
		val tuidFragments = tuid.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(expectedNamespaceUri, tuidFragments.get(0));
		Assert.assertNotNull(tuidFragments.get(1));
		Assert.assertEquals(expectedIdentifier, tuidFragments.get(2));
	}
	
}