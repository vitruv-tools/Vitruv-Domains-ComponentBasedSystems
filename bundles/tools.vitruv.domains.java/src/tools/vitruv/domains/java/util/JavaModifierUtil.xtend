package tools.vitruv.domains.java.util

import edu.kit.ipd.sdq.activextendannotations.Utility
import java.util.List
import java.util.Objects
import org.emftext.language.java.modifiers.AnnotationInstanceOrModifier
import org.emftext.language.java.modifiers.Modifier
import org.emftext.language.java.modifiers.Private
import org.emftext.language.java.modifiers.Protected
import org.emftext.language.java.modifiers.Public

/**
 * General utilities related to Java modifiers.
 */
@Utility
class JavaModifierUtil {

	static val List<Class<? extends Modifier>> JAVA_VISIBILITY_MODIFIER_TYPES = #[Public, Protected, Private]

	/**
	 * Checks if the given {@link Modifier} is a Java visibility modifier.
	 */
	static def boolean isVisibilityModifier(Modifier modifier) {
		return JAVA_VISIBILITY_MODIFIER_TYPES.exists[isInstance(modifier)]
	}

	/**
	 * Checks if the given {@link AnnotationInstanceOrModifier} is a Java
	 * visibility modifier.
	 */
	static def boolean isVisibilityModifier(AnnotationInstanceOrModifier modifier) {
		return modifier instanceof Modifier && (modifier as Modifier).isVisibilityModifier
	}

	/**
	 * Maps the given modifiers to an {@link Iterable} of their contained
	 * visibility modifiers.
	 */
	static def Iterable<Modifier> getVisibilityModifiers(Iterable<? extends AnnotationInstanceOrModifier> modifiers) {
		return modifiers.filter(Modifier).filter[isVisibilityModifier]
	}

	/**
	 * Produces a list of String representations of the given modifiers.
	 * <p>
	 * This may for example be useful for debug or exception messages.
	 */
	static def List<String> getModifierNames(Iterable<? extends AnnotationInstanceOrModifier> modifiers) {
		return modifiers.map[it.class.name].toList
	}

	/**
	 * Checks if the given modifiers are considered equal.
	 * <p>
	 * The modifiers are considered equal if they are either both
	 * <code>null</code> or of the same type.
	 */
	static def boolean isEqualModifier(Modifier modifier1, Modifier modifier2) {
		// Comparing their EClasses should be sufficient.
		return Objects.equals(modifier1?.eClass, modifier2?.eClass)
	}
}
