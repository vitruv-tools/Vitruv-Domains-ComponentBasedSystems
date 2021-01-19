package tools.vitruv.domains.java.ui.monitorededitor.changeclassification.events;

import org.eclipse.jdt.core.dom.Javadoc;

public abstract class JavaDocEvent extends ChangeClassifyingEvent {

	public final Javadoc comment;

	public JavaDocEvent(Javadoc comment) {
		this.comment = comment;
	}

	@Override
	public String toString() {
		return "JavaDocEvent [comment=" + this.comment.toString() + "]";
	}

}
