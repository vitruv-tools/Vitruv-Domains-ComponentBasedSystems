package tools.vitruv.domains.emfprofiles

import org.eclipse.emf.ecore.EPackage
import org.modelversioning.emfprofileapplication.EMFProfileApplicationPackage


final class EmfProfilesNamespace {
	private new() {}

	// MM Namespaces
	public static final EPackage ROOT_PACKAGE = EMFProfileApplicationPackage.eINSTANCE;
	public static final String METAMODEL_NAMESPACE = EMFProfileApplicationPackage.eNS_URI;
	
}