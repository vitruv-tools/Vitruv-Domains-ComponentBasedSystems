package tools.vitruv.domains.java.ui.monitorededitor.changeclassification;

import java.util.Collection;
import java.util.Optional;

import tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events.ChangeClassifyingEventExtension;
import tools.vitruv.framework.change.description.VitruviusChange;

/**
 * Visitor for {@link ChangeClassifyingEventExtension}s which is responsible for
 * converting a predefined list of {@link ChangeClassifyingEventExtension}s to
 * {@link VitruviusChange}s.
 */
public interface ChangeEventExtendedVisitor {

	public Optional<VitruviusChange> visit(ChangeClassifyingEventExtension changeClassifyingEvent);

	public Collection<Class<? extends ChangeClassifyingEventExtension>> getTreatedClasses();

}
