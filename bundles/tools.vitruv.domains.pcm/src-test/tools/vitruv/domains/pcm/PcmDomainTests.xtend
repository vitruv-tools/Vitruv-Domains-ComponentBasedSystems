package tools.vitruv.domains.pcm

import org.palladiosimulator.pcm.repository.RepositoryFactory
import de.uka.ipd.sdq.identifier.Identifier
import org.palladiosimulator.pcm.PcmPackage
import de.uka.ipd.sdq.identifier.IdentifierPackage
import org.eclipse.emf.ecore.EObject
import org.palladiosimulator.pcm.repository.RepositoryPackage
import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertTrue
import static org.junit.jupiter.api.Assertions.assertNotNull
import static org.junit.jupiter.api.Assertions.assertEquals

class PcmDomainTests {
	static val TEST_NAME = "Test";

	private def PcmDomain getPcmDomain() {
		return new PcmDomainProvider().getDomain();
	}

	@Test
	def void testResponsibilityChecks() {
		val component = RepositoryFactory.eINSTANCE.createBasicComponent();
		val pcmMetamodel = getPcmDomain();
		assertTrue(
			pcmMetamodel.isInstanceOfDomainMetamodel(component),
			"Metamodel support only " + pcmMetamodel.nsUris + ", but not " + component.eClass.EPackage.nsURI +
				" of component"
		);
		assertNotNull(
			pcmMetamodel.calculateTuid(component),
			"Metamodel has Tuid only for elements of " + pcmMetamodel.nsUris + ", but not of component's " +
				component.eClass.EPackage.nsURI
		);
	}

	@Test
	def void testIdentifierTuidInRepositoryPackage() {
		testIdentifierTuid(RepositoryFactory.eINSTANCE.createBasicComponent(), "BasicComponent");
		testIdentifierTuid(RepositoryFactory.eINSTANCE.createCompositeComponent(), "CompositeComponent");
		testIdentifierTuid(RepositoryFactory.eINSTANCE.createCollectionDataType(), "CollectionDataType");
		testIdentifierTuid(RepositoryFactory.eINSTANCE.createOperationInterface(), "OperationInterface");
		testIdentifierTuid(RepositoryFactory.eINSTANCE.createOperationProvidedRole(), "OperationProvidedRole");
	}

	@Test
	def void testNameTuidInRepositoryPackage() {
		val parameter = RepositoryFactory.eINSTANCE.createParameter();
		parameter.parameterName = TEST_NAME;
		assertTuid(parameter, PcmPackage.eNS_URI,
			"<root>-_-Parameter-_-" + RepositoryPackage.Literals.PARAMETER__PARAMETER_NAME.name + "=" +
				parameter.parameterName);
	}

	private def testIdentifierTuid(Identifier identifier, String typeName) {
		identifier.id = TEST_NAME;
		assertTuid(identifier, PcmPackage.eNS_URI,
			"<root>-_-" + typeName + "-_-" + IdentifierPackage.Literals.IDENTIFIER__ID.name + "=" + identifier.id);
	}

//	private def testNamedTuid(NamedElement named) {
//		named.entityName = TEST_NAME;
//		assertTuid(named, PcmPackage.eNS_URI, EntityPackage.Literals.NAMED_ELEMENT__ENTITY_NAME.name + "=" + named.entityName);
//	}
	private def void assertTuid(EObject object, String expectedNamespaceUri, String expectedIdentifier) {
		val tuidFragments = getPcmDomain().calculateTuid(object).toString.split("#");
		assertEquals(3, tuidFragments.length);
		assertEquals(expectedNamespaceUri, tuidFragments.get(0));
		assertNotNull(tuidFragments.get(1));
		assertEquals(expectedIdentifier, tuidFragments.get(2));
	}

}
