package tools.vitruv.domains.java.ui.monitorededitor.changeclassification

import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.emf.common.util.URI
import org.eclipse.xtend.lib.annotations.Accessors

@FinalFieldsConstructor
class ResourceChange {
	@Accessors(PUBLIC_GETTER)
	val URI oldResourceURI
	@Accessors(PUBLIC_GETTER)
	val URI newResourceURI
}