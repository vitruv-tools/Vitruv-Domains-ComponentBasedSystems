package tools.vitruv.domains.pcm

import static extension tools.vitruv.domains.pcm.PcmNamespace.*;
import tools.vitruv.framework.domains.AbstractVitruvDomain

final class PcmDomain extends AbstractVitruvDomain {
	static final String METAMODEL_NAME = "PCM";

	package new() {
		super(
			METAMODEL_NAME,
			ROOT_PACKAGE,
			#[REPOSITORY_FILE_EXTENSION, SYSTEM_FILE_EXTENSION]
		);
	}

}
