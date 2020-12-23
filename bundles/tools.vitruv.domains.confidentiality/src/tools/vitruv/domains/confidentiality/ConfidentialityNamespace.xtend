package tools.vitruv.domains.confidentiality

import org.eclipse.emf.ecore.EPackage
import edu.kit.kastel.scbs.confidentiality.ConfidentialityPackage

final class ConfidentialityNamespace {
	private new() {
	}

	// file extensions
	public static final String FILE_EXTENSION = "confidentiality";

	// MM Namespaces
	public static final EPackage ROOT_PACKAGE = ConfidentialityPackage.eINSTANCE;
	public static final String METAMODEL_NAMESPACE = ConfidentialityPackage.eNS_URI;
	
}