package tools.vitruv.domains.java

import org.emftext.language.java.classifiers.ClassifiersFactory
import org.emftext.language.java.JavaPackage
import org.emftext.language.java.commons.NamedElement
import org.eclipse.emf.ecore.EObject
import org.emftext.language.java.classifiers.Classifier
import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertTrue
import static org.junit.jupiter.api.Assertions.assertNotNull
import static org.junit.jupiter.api.Assertions.assertEquals

class JavaDomainTests {
	static val TEST_NAME = "Test";
	
	private def JavaDomain getJavaDomain() {
		return new JavaDomainProvider().getDomain();
	}
	
	@Test
	def void testResponsibilityChecks() {
		val component = ClassifiersFactory.eINSTANCE.createClass();
		val javaDomain = getJavaDomain();
		assertTrue(javaDomain.isInstanceOfDomainMetamodel(component));
		assertTrue(javaDomain.calculateTuid(component) !== null);
	}
	
	@Test
	def void testTuidInClassifiersPackage() {
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
		assertEquals(3, tuidFragments.length);
		assertEquals(expectedNamespaceUri, tuidFragments.get(0));
		assertNotNull(tuidFragments.get(1));
		assertEquals(expectedIdentifier, tuidFragments.get(2));
	}
	
}