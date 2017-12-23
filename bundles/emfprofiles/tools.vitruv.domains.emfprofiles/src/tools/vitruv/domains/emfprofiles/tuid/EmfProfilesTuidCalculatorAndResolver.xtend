 package tools.vitruv.domains.emfprofiles.tuid

import org.eclipse.emf.ecore.EObject
import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver
import org.modelversioning.emfprofileapplication.StereotypeApplication
import org.modelversioning.emfprofileapplication.ProfileApplication
import org.modelversioning.emfprofileapplication.ProfileImport

class EmfProfilesTuidCalculatorAndResolver extends AttributeTuidCalculatorAndResolver {

	new(String nsPrefix) {
		super(nsPrefix)
	}

	override calculateIndividualTuidDelegator(EObject eObject) {
		dispatchedCalculateIndividualTuidDelegator(eObject);	
	}
	
	def dispatch String dispatchedCalculateIndividualTuidDelegator(EObject eObject) {
		super.calculateIndividualTuidDelegator(eObject);	
	}
	
	def dispatch String dispatchedCalculateIndividualTuidDelegator(ProfileImport profileImport) {
		return "type" + if (profileImport.profile !== null) "=" + profileImport.profile.name;
	}
	
	def dispatch String dispatchedCalculateIndividualTuidDelegator(ProfileApplication application) {
		val type = "type" + if (!application.importedProfiles.empty) "=" + 
			application.importedProfiles.tail.fold(application.importedProfiles.head.nameOrEmpty, 
				[concat, current | concat + "+" + current.nameOrEmpty]) else "";
		return "<root>" + SUBDIVIDER + "profileApplication" + SUBDIVIDER + type;
	}
	
	private def getNameOrEmpty(ProfileImport profileImport) {
		return if (!profileImport.profile?.name.nullOrEmpty) profileImport.profile.name else "" 
	}
	
	def dispatch String dispatchedCalculateIndividualTuidDelegator(StereotypeApplication application) {
		val type = "type" + if (application.stereotype !== null) "=" + application.stereotype.name else "";
		val potentialObjectIdentifier = application.appliedTo?.eClass?.EAllAttributes?.filter[#{"id", "name", "entityName"}.contains(it.name)];
		val objectIdentifier = if (!potentialObjectIdentifier.nullOrEmpty) potentialObjectIdentifier.get(0);
		val objectIdentifierName = if (objectIdentifier !== null) objectIdentifier.name else "none";
		val objectIdentifierValue = if (objectIdentifier !== null) application.appliedTo.eGet(objectIdentifier) else "empty";
		val appliedTo = "appliedTo" + if (application.appliedTo !== null) "=" + objectIdentifierName + "=" + objectIdentifierValue;
		return "stereotypeApplication" + SUBDIVIDER + type + SUBDIVIDER + appliedTo;
	}

}
