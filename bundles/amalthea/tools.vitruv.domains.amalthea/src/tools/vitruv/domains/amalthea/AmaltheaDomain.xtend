package tools.vitruv.domains.amalthea

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import tools.vitruv.framework.tuid.TuidCalculatorAndResolver
import tools.vitruv.framework.domains.AbstractVitruvDomain
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator
import static tools.vitruv.domains.amalthea.AmaltheaNamespace.*
import org.eclipse.app4mc.amalthea.model.AmaltheaPackage

class AmaltheaDomain extends AbstractVitruvDomain {
	public static final String METAMODEL_NAME = "Amalthea"
	
	package new() {
		super(METAMODEL_NAME, ROOT_PACKAGE, generateTuidCalculator(), FILE_EXTENSION);
	}

	def protected static TuidCalculatorAndResolver generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolver(METAMODEL_NAMESPACE, 
			#[AmaltheaPackage.eINSTANCE.INamedElement_Name.name]
		);
	}
	
	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}
	
}