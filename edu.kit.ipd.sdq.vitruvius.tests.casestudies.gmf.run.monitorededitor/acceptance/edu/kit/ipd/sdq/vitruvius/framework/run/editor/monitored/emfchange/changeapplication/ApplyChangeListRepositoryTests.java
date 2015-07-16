/*******************************************************************************
 * Copyright (c) 2014 Felix Kutzner.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Felix Kutzner - initial implementation.
 ******************************************************************************/

package edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.changeapplication;

import java.net.URL;

import org.junit.Test;

import org.palladiosimulator.pcm.core.CoreFactory;
import org.palladiosimulator.pcm.core.PCMRandomVariable;
import org.palladiosimulator.pcm.parameter.ParameterFactory;
import org.palladiosimulator.pcm.parameter.VariableCharacterisation;
import org.palladiosimulator.pcm.parameter.VariableCharacterisationType;
import org.palladiosimulator.pcm.parameter.VariableUsage;
import org.palladiosimulator.pcm.repository.BasicComponent;
import org.palladiosimulator.pcm.repository.ComponentType;
import org.palladiosimulator.pcm.repository.InfrastructureProvidedRole;
import org.palladiosimulator.pcm.repository.OperationProvidedRole;
import org.palladiosimulator.pcm.repository.PassiveResource;
import org.palladiosimulator.pcm.repository.RepositoryFactory;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.test.testmodels.Files;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.test.testmodels.Metamodels;

public class ApplyChangeListRepositoryTests extends AbstractChangeApplicatorTests<BasicComponent> {

    @Override
    protected void registerMetamodels() {
        Metamodels.registerRepositoryMetamodel();
    }

    @Override
    protected URL getModel() {
        return Files.PALLADIO_REPOSITORY;
    }

    @Test
    public void singleSetAttribute() {
        sourceRoot.setEntityName("!" + sourceRoot.getEntityName());
        synchronizeChangesAndAssertEquality();
    }

    @Test
    public void setComponentType() {
        sourceRoot.setComponentType(ComponentType.INFRASTRUCTURE_COMPONENT);
        synchronizeChangesAndAssertEquality();
    }

    @Test
    public void addPassiveResource() {
        PassiveResource pr = RepositoryFactory.eINSTANCE.createPassiveResource();
        sourceRoot.getPassiveResource_BasicComponent().add(pr);
        synchronizeChangesAndAssertEquality();
    }

    @Test
    public void addElementOfOtherModel() {
        VariableUsage vr = ParameterFactory.eINSTANCE.createVariableUsage();
        sourceRoot.getComponentParameterUsage_ImplementationComponentType().add(vr);
        synchronizeChangesAndAssertEquality();
    }

    @Test
    public void compoundAddChanges() {
        PassiveResource pr = RepositoryFactory.eINSTANCE.createPassiveResource();
        sourceRoot.getPassiveResource_BasicComponent().add(pr);

        PCMRandomVariable variable = CoreFactory.eINSTANCE.createPCMRandomVariable();
        pr.setCapacity_PassiveResource(variable);

        VariableUsage vr = ParameterFactory.eINSTANCE.createVariableUsage();
        sourceRoot.getComponentParameterUsage_ImplementationComponentType().add(vr);

        synchronizeChangesAndAssertEquality();
    }

    @Test
    public void addPCMRandomVariable() {
        VariableUsage vu = ParameterFactory.eINSTANCE.createVariableUsage();
        sourceRoot.getComponentParameterUsage_ImplementationComponentType().add(vu);
        VariableCharacterisation vc = ParameterFactory.eINSTANCE.createVariableCharacterisation();
        vc.setType(VariableCharacterisationType.STRUCTURE);
        PCMRandomVariable pcmr = CoreFactory.eINSTANCE.createPCMRandomVariable();
        pcmr.setSpecification("1");
        vc.setSpecification_VariableCharacterisation(pcmr);
        vu.getVariableCharacterisation_VariableUsage().add(vc);

        synchronizeChangesAndAssertEquality();
    }

    @Test
    public void addMultipleProvidedRoles() {
        // Connect BC1 to IP1 using a ProvidedRole.
        OperationProvidedRole bc1ProvidedIP1 = RepositoryFactory.eINSTANCE.createOperationProvidedRole();
        sourceRoot.getProvidedRoles_InterfaceProvidingEntity().add(bc1ProvidedIP1);

        // Connect BC1 to IP2 using an InfrastructureProvidedRole.
        InfrastructureProvidedRole ipr = RepositoryFactory.eINSTANCE.createInfrastructureProvidedRole();
        sourceRoot.getProvidedRoles_InterfaceProvidingEntity().add(ipr);

        synchronizeChangesAndAssertEquality();
    }
}
