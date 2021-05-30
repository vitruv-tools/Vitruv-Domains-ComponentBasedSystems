/*******************************************************************************
 * Copyright (c) 2006-2012
 * Software Technology Group, Dresden University of Technology
 * DevBoost GmbH, Berlin, Amtsgericht Charlottenburg, HRB 140026
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Software Technology Group - TU Dresden, Germany;
 *   DevBoost GmbH - Berlin, Germany
 *      - initial API and implementation
 ******************************************************************************/
package tools.vitruv.domains.java.util.jamoppparser;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.emftext.language.java.JavaPackage;

import jamopp.resource.JavaResource2Factory;

/**
 * Registers the {@link JavaResource2Factory} to load JaMoPP resources from
 * .java files or java content-type InputStreams.
 */
public class Jamopp {

    private final ResourceSet rs;

    protected Jamopp() {
        this.rs = new ResourceSetImpl();
        this.setUp();
    }

    public ResourceSet getResourceSet() {
        return this.rs;
    }

    protected void setUp() {
        EPackage.Registry.INSTANCE.put("http://www.emftext.org/java", JavaPackage.eINSTANCE);
        Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("java",
                new JavaResource2Factory());
        Resource.Factory.Registry.INSTANCE.getContentTypeToFactoryMap().put("java",
                new JavaResource2Factory());
        Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put(Resource.Factory.Registry.DEFAULT_EXTENSION,
                new XMIResourceFactoryImpl());
    }

    protected void parseResource(final File file) throws IOException {
        this.loadResource(file.getCanonicalPath());
    }

    protected void loadResource(final String filePath) throws IOException {
        this.loadResource(URI.createFileURI(filePath));
    }

    protected void loadResource(final URI uri) throws IOException {
        this.rs.getResource(uri, true);
    }

    // in-memory loading
    public void loadResource(final URI uri, final InputStream in) throws IOException {
        // rs.getResource(uri, true);
        final Resource r = this.rs.createResource(uri, "java");
        r.load(in, null);
    }
}
