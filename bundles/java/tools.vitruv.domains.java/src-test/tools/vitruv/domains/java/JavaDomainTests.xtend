package tools.vitruv.domains.java

import org.junit.Assert
import org.junit.Test
import org.emftext.language.java.classifiers.ClassifiersFactory
import org.emftext.language.java.JavaPackage
import org.emftext.language.java.commons.NamedElement
import org.eclipse.emf.ecore.EObject
import org.emftext.language.java.classifiers.Classifier

class JavaDomainTests {
	private static val TEST_NAME = "Test";
	
	private def JavaDomain getJavaDomain() {
		return new JavaDomainProvider().getDomain();
	}
	
	@Test
	public def void testResponsibilityChecks() {
		val component = ClassifiersFactory.eINSTANCE.createClass();
		val javaDomain = getJavaDomain();
		Assert.assertTrue(javaDomain.isInstanceOfDomainMetamodel(component));
		Assert.assertTrue(javaDomain.calculateTuid(component) !== null);
	}
	
	@Test
	def public void testTuidInClassifiersPackage() {
		testTuid(ClassifiersFactory.eINSTANCE.createClass());
		testTuid(ClassifiersFactory.eINSTANCE.createInterface());
	}
	
	private def dispatch testTuid(NamedElement named) {
		throw new UnsupportedOperationException();
	}
	
	private def dispatch testTuid(Classifier classifier) {
		classifier.name = TEST_NAME;
		assertTuid(classifier, JavaPackage.eNS_URI, "classifier-_-" + classifier.name);
	}
	
	private def void assertTuid(EObject object, String expectedNamespaceUri, String expectedIdentifier) {
		val tuidFragments = javaDomain.calculateTuid(object).toString.split("#");
		Assert.assertEquals(3, tuidFragments.length);
		Assert.assertEquals(expectedNamespaceUri, tuidFragments.get(0));
		Assert.assertNotNull(tuidFragments.get(1));
		Assert.assertEquals(expectedIdentifier, tuidFragments.get(2));
	}
	
}