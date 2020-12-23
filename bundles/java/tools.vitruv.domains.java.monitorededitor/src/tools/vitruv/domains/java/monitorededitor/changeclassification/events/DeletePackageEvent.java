package tools.vitruv.domains.java.monitorededitor.changeclassification.events;

import org.eclipse.core.resources.IResource;

public class DeletePackageEvent extends PackageEvent {

    public DeletePackageEvent(String packageName, IResource iResource) {
        super(packageName, iResource);
    }

    @Override
    public String toString() {
        return "DeletePackageEvent [package=" + this.packageName + "]";
    }

    @Override
    public void accept(ChangeEventVisitor visitor) {
        visitor.visit(this);
    }

}
