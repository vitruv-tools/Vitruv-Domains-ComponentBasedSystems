package tools.vitruv.domains.confidentiality

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import edu.kit.kastel.scbs.confidentiality.ConfidentialityPackage
import static tools.vitruv.domains.confidentiality.ConfidentialityNamespace.*;
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain

class ConfidentialityDomain extends AbstractTuidAwareVitruvDomain {
	public static final String METAMODEL_NAME = "Confidentiality"
	
	package new() {
		super(METAMODEL_NAME, ROOT_PACKAGE, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolver(METAMODEL_NAMESPACE, 
			#[ConfidentialityPackage.Literals.IDENTIFIED_ELEMENT__ID.name, ConfidentialityPackage.Literals.NAMED_ELEMENT__NAME.name]
		);
	}
	
	
}