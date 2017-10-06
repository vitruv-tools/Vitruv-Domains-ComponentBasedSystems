/*
 * Copyright (c) 2005, 2011 IBM Corporation, CEA, and others.
 * All rights reserved.   This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   IBM - initial API and implementation
 *   Kenn Hussey (CEA) - 327039
 *
 * $Id: UMLResourceImpl.java,v 1.4 2006/12/14 15:49:34 khussey Exp $
 */
package org.eclipse.uml2.uml.internal.resource;

import org.eclipse.emf.common.util.URI;

/**
 * Overwrites {@link UMLResourceImpl} deactivating deprecated resource UUID usage.
 * 
 * @author Heiko Klare
 */
@SuppressWarnings("restriction")
public class UMLResourceImplWithoutUUIDs
		extends UMLResourceImpl {

	public UMLResourceImplWithoutUUIDs(URI uri) {
		super(uri);
	}

	@Override
	protected boolean useUUIDs() {
		return false;
	}

}
