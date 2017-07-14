package tools.vitruv.domains.asem

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import edu.kit.ipd.sdq.ASEM.base.BasePackage
import static tools.vitruv.domains.asem.AsemNamespace.*;
import tools.vitruv.framework.domains.AbstractVitruvDomain
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator

class AsemDomain extends AbstractVitruvDomain {
	public static final String METAMODEL_NAME = "ASEM"
	
	package new() {
		super(METAMODEL_NAME, ROOT_PACKAGE, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolver(METAMODEL_NAMESPACE, 
			#[BasePackage.Literals.IDENTIFIABLE__ID.name, BasePackage.Literals.NAMED__NAME.name]
		);
	}
	
	
	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}
	
}