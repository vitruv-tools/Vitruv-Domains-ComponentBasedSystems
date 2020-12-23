/*
 * Copyright (c) 2005, 2014 IBM Corporation, CEA, and others.
 * All rights reserved.   This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   IBM - initial API and implementation
 *   Kenn Hussey (CEA) - 327039, 351774, 418466
 *
 */
package org.eclipse.uml2.uml.internal.resource;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.uml2.uml.resource.UMLResource;

/**
 * Overwrites {@link UMLResourceFactoryImpl} deactivating deprecated resource UUID usage.
 * 
 * @author Heiko Klare
 */
@SuppressWarnings("restriction")
public class UMLResourceWithoutUUIDsFactoryImpl
		extends UMLResourceFactoryImpl
		implements UMLResource.Factory {

	/**
	 * Creates an instance of the resource.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Resource createResourceGen(URI uri) {
		UMLResource result = new UMLResourceImplWithoutUUIDs(uri);
		result.setEncoding(UMLResource.DEFAULT_ENCODING);
		return result;
	}

}
