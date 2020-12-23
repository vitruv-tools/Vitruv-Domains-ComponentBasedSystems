package tools.vitruv.domains.emfprofiles

import org.eclipse.emf.ecore.EPackage
import org.modelversioning.emfprofileapplication.EMFProfileApplicationPackage
import org.modelversioning.emfprofile.EMFProfilePackage

final class EmfProfilesNamespace {
	private new() {}

	// MM Namespaces
	public static final EPackage ROOT_PACKAGE = EMFProfileApplicationPackage.eINSTANCE;
	public static final EPackage PROFILE_PACKAGE = EMFProfilePackage.eINSTANCE;
	public static final String METAMODEL_NAMESPACE = EMFProfileApplicationPackage.eNS_URI;
	
}