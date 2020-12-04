package tools.vitruv.domains.emfprofiles

import org.junit.Test
import org.junit.Assert
import org.eclipse.emf.ecore.EObject
import org.junit.Before
import tools.vitruv.framework.tuid.TuidManager
import org.modelversioning.emfprofile.EMFProfileFactory
import org.modelversioning.emfprofileapplication.EMFProfileApplicationFactory
import org.modelversioning.emfprofileapplication.ProfileImport

class EmfProfilesDomainTest {
	static val TEST_PROFILE_NAME = "Test";
	var EmfProfilesDomain emfProfilesDomain;
	
	@Before
	def void setup() {
		TuidManager.instance.reinitialize();
		emfProfilesDomain = new EmfProfilesDomainProvider().domain;
	}
	
	@Test
	def void testProfileImport() {
		val profileImport = createProfileImport;
		profileImport.assertTuidCalculatability;
		profileImport.profile = EMFProfileFactory.eINSTANCE.createProfile;
		profileImport.assertTuidCalculatability;
		profileImport.profile.name = TEST_PROFILE_NAME;
		profileImport.assertTuidCalculatability;
	}
	
	private def ProfileImport createProfileImport() {
		return EMFProfileApplicationFactory.eINSTANCE.createProfileImport();
	}
	
	private def void setProfileForImport(ProfileImport profileImport, String name) {
		profileImport.profile = EMFProfileFactory.eINSTANCE.createProfile;
		profileImport.profile.name = name;
	}
	
	@Test
	def void testProfileApplication() {
		val profileApplication = EMFProfileApplicationFactory.eINSTANCE.createProfileApplication();
		profileApplication.assertTuidCalculatability
		val profileImport = createProfileImport;
		profileApplication.importedProfiles += profileImport;
		profileApplication.assertTuidCalculatability;
		profileImport.profileForImport = TEST_PROFILE_NAME;
		profileApplication.assertTuidCalculatability;
		val profileImport2 = createProfileImport;
		profileApplication.importedProfiles += profileImport2;
		profileApplication.assertTuidCalculatability;
		profileImport.profileForImport = TEST_PROFILE_NAME + "2";
		profileApplication.assertTuidCalculatability;
	}
	
	@Test
	def void testStereotypeApplication() {
		val stereotypeApplication = EMFProfileApplicationFactory.eINSTANCE.createStereotypeApplication();
		stereotypeApplication.assertTuidCalculatability;
		// This has no name
		stereotypeApplication.appliedTo = EMFProfileApplicationFactory.eINSTANCE.createProfileImport;
		stereotypeApplication.assertTuidCalculatability;
		// This has a name
		val profile = EMFProfileFactory.eINSTANCE.createProfile;
		stereotypeApplication.appliedTo = profile;
		stereotypeApplication.assertTuidCalculatability;
		profile.name = TEST_PROFILE_NAME;
		stereotypeApplication.assertTuidCalculatability;
	}
	
	private def assertTuidCalculatability(EObject object) {
		Assert.assertTrue(emfProfilesDomain.isInstanceOfDomainMetamodel(object));
		Assert.assertTrue(emfProfilesDomain.calculateTuid(object) !== null);
	}
	
}