package tools.vitruv.domains.uml

import org.junit.jupiter.api.BeforeEach
import tools.vitruv.framework.vsum.VirtualModelBuilder
import tools.vitruv.testutils.TestProject
import java.nio.file.Path
import tools.vitruv.testutils.ChangePublishingTestView
import tools.vitruv.testutils.TestUserInteraction
import static tools.vitruv.testutils.UriMode.FILE_URIS
import tools.vitruv.framework.domains.repository.VitruvDomainRepositoryImpl
import java.util.List
import tools.vitruv.testutils.TestView
import tools.vitruv.framework.vsum.VirtualModel
import org.junit.jupiter.api.Test
import org.eclipse.uml2.uml.UMLFactory
import org.eclipse.uml2.uml.Model
import static org.hamcrest.MatcherAssert.assertThat
import static org.hamcrest.CoreMatchers.is
import org.junit.jupiter.api.^extension.ExtendWith
import tools.vitruv.testutils.TestProjectManager
import tools.vitruv.testutils.TestLogging
import tools.vitruv.testutils.RegisterMetamodelsInStandalone

@ExtendWith(TestProjectManager, TestLogging, RegisterMetamodelsInStandalone)
class UmlDomainResourceTest {
	extension var TestView testView
	var VirtualModel vsum 
	
	@BeforeEach
	def void setupVitruv(@TestProject Path projectFolder, @TestProject(variant = "vsum") Path vsumFolder) {
		val userInteraction = new TestUserInteraction()
		val umlDomainRepo = new VitruvDomainRepositoryImpl(List.of(new UmlDomainProvider().domain))
		vsum = new VirtualModelBuilder()
			.withStorageFolder(vsumFolder)
			.withUserInteractorForResultProvider(new TestUserInteraction.ResultProvider(userInteraction))
			.withDomainRepository(umlDomainRepo)
			.buildAndInitialize()
		testView = new ChangePublishingTestView(projectFolder, userInteraction, FILE_URIS, vsum, umlDomainRepo)
	}
	
	@Test
	def void consistentUuids() {
		val uuidResolver = vsum.uuidResolver
		
		val initialModel = UMLFactory.eINSTANCE.createModel
		resourceAt(Path.of("test.uml")).propagate [
			contents += initialModel
		]
		
		val loadedModel = Model.from(Path.of("test.uml"))
		
		assertThat(uuidResolver.getUuid(initialModel), is(uuidResolver.getUuid(loadedModel)))
	}
}