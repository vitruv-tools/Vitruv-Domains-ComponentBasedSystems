package tools.vitruv.domains.amalthea

import org.junit.Test
import org.junit.Assert
import org.eclipse.emf.ecore.EObject
import org.junit.Before
import tools.vitruv.framework.tuid.TuidManager
import org.eclipse.app4mc.amalthea.model.AmaltheaFactory
import org.eclipse.app4mc.amalthea.model.INamedElement
import org.eclipse.app4mc.amalthea.model.AmaltheaPackage

class AmaltheaDomainTest {
	private static val TEST_NAME = "Test";
	private var AmaltheaDomain asemDomain;
	
	@Before
	public def void setup() {
		TuidManager.instance.reinitialize();
		asemDomain = new AmaltheaDomainProvider().domain;
	}
	
	@Test
	public def void testResponsibilityChecks() {
		val clazz = AmaltheaFactory.eINSTANCE.createStimulusEvent();
		Assert.assertTrue(asemDomain.isInstanceOfDomainMetamodel(clazz));
		Assert.assertTrue(asemDomain.calculateTuid(clazz) !== null);
	}
	
	@Test
	def public void testNamedTuids() {
		testNamedTuid(AmaltheaFactory.eINSTANCE.createConnector());
	}
	
	private def testNamedTuid(INamedElement named) {
		named.name = TEST_NAME;
		testTuid(named);
	}
	
	private def testTuid(INamedElement named) {
		assertTuid(named, AmaltheaPackage.eNS_URI, "<root>-_-" + named.eClass.name + "-_-" + AmaltheaPackage.eINSTANCE.INamedElement_Name.name + "=" + named.name);
	}
	
	private def void assertTuid(EObject object, String expectedNamespaceUri, String expectedIdentifier) {
		val tuidFragments = asemDomain.calculateTuid(object).toString.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(expectedNamespaceUri, tuidFragments.get(0));
		Assert.assertNotNull(tuidFragments.get(1));
		Assert.assertEquals(expectedIdentifier, tuidFragments.get(2));
	}
	
}