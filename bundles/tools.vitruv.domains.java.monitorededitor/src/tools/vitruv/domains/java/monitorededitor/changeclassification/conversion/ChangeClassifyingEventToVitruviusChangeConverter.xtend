package tools.vitruv.domains.java.monitorededitor.changeclassification.conversion

import tools.vitruv.domains.java.monitorededitor.changeclassification.events.ChangeClassifyingEvent
import tools.vitruv.framework.change.description.VitruviusChange
import java.util.Optional

interface ChangeClassifyingEventToVitruviusChangeConverter {

	def Optional<VitruviusChange> convert(ChangeClassifyingEvent event)

}
