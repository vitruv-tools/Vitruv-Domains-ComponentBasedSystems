package tools.vitruv.domains.java.util.jamoppparser;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.eclipse.core.runtime.IPath;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.emftext.language.java.containers.CompilationUnit;

public class JamoppParser {

    public CompilationUnit parseCompilationUnitFromDisk(IPath compilationUnitPath) throws IOException {
        String path = compilationUnitPath.toOSString();
        return parseCompilationUnitFromDisk(path);
    }

    public CompilationUnit parseCompilationUnitFromDisk(String absPath) throws IOException {
        Jamopp jamopp = new Jamopp();
        File compilationUnitFile = new File(absPath);
        jamopp.parseResource(compilationUnitFile);
        return getCompilationUnit(jamopp);
    }

    public CompilationUnit parseCompilationUnitFromDisk(URI uri) throws IOException {
        Jamopp jamopp = new Jamopp();
        jamopp.loadResource(uri);
        return getCompilationUnit(jamopp);
    }

    public CompilationUnit parseCompilationUnitFromInputStream(URI uri, InputStream in) throws IOException {
        Jamopp jamopp = new Jamopp();
        jamopp.loadResource(uri, in);
        return getCompilationUnit(jamopp);
    }

    private CompilationUnit getCompilationUnit(Jamopp jamopp) {
        ResourceSet rs = jamopp.getResourceSet();
        EObject jamoppCU = rs.getResources().get(0).getAllContents().next();
        if (!(jamoppCU instanceof CompilationUnit))
            // e.g. empty .java files are 'EmptyModel's, not CompilationUnits
            return null;
        else
            return (CompilationUnit) jamoppCU;
    }

}
