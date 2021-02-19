package tools.vitruv.domains.pcm

import static extension tools.vitruv.domains.pcm.PcmNamespace.*;
import tools.vitruv.framework.domains.AbstractVitruvDomain

final class PcmDomain extends AbstractVitruvDomain {
	static final String METAMODEL_NAME = "PCM";
	boolean shouldTransitivelyPropagateChanges = false;

	package new() {
		super(
			METAMODEL_NAME,
			ROOT_PACKAGE,
			#[REPOSITORY_FILE_EXTENSION, SYSTEM_FILE_EXTENSION]
		);
	}

	override shouldTransitivelyPropagateChanges() {
		return shouldTransitivelyPropagateChanges;
	}

	/**
	 * Calling this methods enable the per default disabled transitive change propagation.
	 * Should only be called for test purposes!
	 */
	def enableTransitiveChangePropagation() {
		shouldTransitivelyPropagateChanges = true
	}

}
