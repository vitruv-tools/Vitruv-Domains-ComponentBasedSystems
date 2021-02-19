package tools.vitruv.domains.emfprofiles

import static tools.vitruv.domains.emfprofiles.EmfProfilesNamespace.*;
import tools.vitruv.framework.domains.AbstractVitruvDomain

class EmfProfilesDomain extends AbstractVitruvDomain {
	public static final String METAMODEL_NAME = "EmfProfiles"
	
	package new() {
		super(METAMODEL_NAME, ROOT_PACKAGE, #{PROFILE_PACKAGE});
	}

}