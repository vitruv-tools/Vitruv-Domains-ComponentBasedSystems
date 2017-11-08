package tools.vitruv.domains.amalthea

import org.eclipse.emf.ecore.EPackage
import org.eclipse.app4mc.amalthea.model.AmaltheaPackage

final class AmaltheaNamespace {
	private new() {
	}

	// file extensions
	public static final String FILE_EXTENSION = "amalthea";

	// MM Namespaces
	public static final EPackage ROOT_PACKAGE = AmaltheaPackage.eINSTANCE;
	public static final String METAMODEL_NAMESPACE = AmaltheaPackage.eNS_URI;
	
}