package tools.vitruv.domains.pcm

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import org.palladiosimulator.pcm.core.entity.EntityPackage
import de.uka.ipd.sdq.identifier.IdentifierPackage
import static extension tools.vitruv.domains.pcm.PcmNamespace.*;
import org.palladiosimulator.pcm.repository.RepositoryPackage
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator
import tools.vitruv.framework.domains.AbstractTuidAwareVitruvDomain

final class PcmDomain extends AbstractTuidAwareVitruvDomain {
	private static final String METAMODEL_NAME = "PCM";
	private boolean shouldTransitivelyPropagateChanges = false;
	
	package new() {
		super(METAMODEL_NAME, ROOT_PACKAGE, 
			generateTuidCalculator(), #[REPOSITORY_FILE_EXTENSION, SYSTEM_FILE_EXTENSION]
		);
	}
	
	def protected static generateTuidCalculator() {
		return new AttributeTuidCalculatorAndResolver(METAMODEL_NAMESPACE, 
			#[IdentifierPackage.Literals.IDENTIFIER__ID.name, RepositoryPackage.Literals.PARAMETER__PARAMETER_NAME.name,
				EntityPackage.Literals.NAMED_ELEMENT__ENTITY_NAME.name, RepositoryPackage.Literals.PRIMITIVE_DATA_TYPE__TYPE.name
			]);
	}
	
	override getBuilderApplicator() {
		return new VitruviusEmfBuilderApplicator();
	}
	
	override shouldTransitivelyPropagateChanges() {
		return shouldTransitivelyPropagateChanges;
	}
	
	/**
	 * Calling this methods enable the per default disabled transitive change propagation.
	 * Should only be called for test purposes!
	 */
	public def enableTransitiveChangePropagation() {
		shouldTransitivelyPropagateChanges = true
	}
	
}