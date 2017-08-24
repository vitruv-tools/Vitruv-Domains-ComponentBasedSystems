package tools.vitruv.domains.caex.tuid;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl;

import tools.vitruv.framework.tuid.AttributeTuidCalculatorAndResolver;
import tools.vitruv.framework.tuid.HierarchicalTuidCalculatorAndResolver;
import tools.vitruv.framework.util.bridges.EcoreBridge;

/**
 * A {@link HierarchicalTuidCalculatorAndResolver} with the same workflow as the {@link AttributeTuidCalculatorAndResolver}.
 * In addition to the attributesNames this TuidCalculator scans the elements for specific
 * rootFeatures that particularly occur on a root element.
 * 
 * @see AttributeTuidCalculatorAndResolver
 * @author Fabian Scheytt
 */
public class AttributeTuidCalculatorAndResolverSpecificRoot extends AttributeTuidCalculatorAndResolver {
	private final List<String> rootFeatures;

	public AttributeTuidCalculatorAndResolverSpecificRoot(final String tuidPrefix, final List<String> attributeNames) {
		super(tuidPrefix,attributeNames);
		this.rootFeatures = new ArrayList<String>();
	}
	
	public AttributeTuidCalculatorAndResolverSpecificRoot(final String tuidPrefix, final List<String> attributeNames, final List<String> rootFeatures) {
		super(tuidPrefix,attributeNames);
		this.rootFeatures = new ArrayList<String>(rootFeatures);
	}


	@Override
	protected String calculateIndividualTuidDelegator(final EObject obj) throws IllegalArgumentException {
		for (String attributeName : this.attributeNames) {
			final String attributeValue = EcoreBridge.getStringValueOfAttribute(obj, attributeName);
			if (null != attributeValue) {
				String subTuid = (obj.eContainingFeature() == null || obj.eContainer() instanceof ChangeDescriptionImpl ? "<root>"
						: obj.eContainingFeature().getName()) + SUBDIVIDER + obj.eClass().getName() + SUBDIVIDER
								+ attributeName + "=" + attributeValue;
				return subTuid;
			} else {
				EStructuralFeature idFeature = obj.eClass().getEStructuralFeature(attributeName);
				if (idFeature != null && !obj.eIsSet(idFeature)) {
					return attributeName;
				}
			}
		}
		for (String attributeName : this.rootFeatures) {
			EStructuralFeature idFeature = obj.eClass().getEStructuralFeature(attributeName);
			if(idFeature!=null) {
				return "<root>";
			}
		}

		throw new IllegalArgumentException(
				"None of '" + String.join("', '", this.attributeNames) + "' found for eObject '" + obj + "'");
	}

}
