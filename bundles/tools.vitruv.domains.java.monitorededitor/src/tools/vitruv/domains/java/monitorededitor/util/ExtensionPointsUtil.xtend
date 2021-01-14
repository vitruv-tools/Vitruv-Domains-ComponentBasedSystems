package tools.vitruv.domains.java.monitorededitor.util

import tools.vitruv.domains.java.monitorededitor.astchangelistener.classification.ConcreteChangeClassifier
import tools.vitruv.framework.util.bridges.EclipseBridge
import java.util.List
import tools.vitruv.framework.util.VitruviusConstants
import edu.kit.ipd.sdq.activextendannotations.Utility
import tools.vitruv.domains.java.monitorededitor.ChangeEventExtendedVisitor

@Utility
class ExtensionPointsUtil {
	static def getRegisteredAstPostChangeClassifiers() {
		getRegisteredExtensions("tools.vitruv.domains.java.monitorededitor.astpostchange", ConcreteChangeClassifier)	
	}
	
	static def getRegisteredAstPostReconcileClassifiers() {
		getRegisteredExtensions("tools.vitruv.domains.java.monitorededitor.astpostreconcile", ConcreteChangeClassifier)	
	}
	
	static def getRegisteredChangeEventExtendedVisitors() {
		getRegisteredExtensions("tools.vitruv.domains.java.monitorededitor.changeeventextendedvisitors", ChangeEventExtendedVisitor)	
	}
	
	private static def <T> List<T> getRegisteredExtensions(String extensionPointName, Class<T> expectedType) {
		return EclipseBridge.getRegisteredExtensions(extensionPointName, VitruviusConstants.getExtensionPropertyName(),
				expectedType);
	}
}