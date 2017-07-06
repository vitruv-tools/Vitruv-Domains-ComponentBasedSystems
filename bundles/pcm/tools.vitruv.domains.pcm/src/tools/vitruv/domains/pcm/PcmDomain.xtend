package tools.vitruv.domains.pcm

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import org.palladiosimulator.pcm.core.entity.EntityPackage
import de.uka.ipd.sdq.identifier.IdentifierPackage
import static extension tools.vitruv.domains.pcm.PcmNamespace.*;
import org.palladiosimulator.pcm.repository.RepositoryPackage
import tools.vitruv.framework.domains.AbstractVitruvDomain

final class PcmDomain extends AbstractVitruvDomain {
	private static final String METAMODEL_NAME = "PCM";
	
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
	
}