package tools.vitruv.domains.java.monitorededitor.changeclassification;

import tools.vitruv.domains.java.monitorededitor.changeclassification.events.ChangeClassifyingEvent;

public interface ChangeOperationListener {
	/**
	 * Is triggered as soon as an event is recognized but not has been processed.
	 */
	void notifyEventOccured();

	/**
	 * Is triggered as soon as an event has been classified.
	 *
	 * @param event the classified event
	 */
	void notifyEventClassified(ChangeClassifyingEvent event);
}
