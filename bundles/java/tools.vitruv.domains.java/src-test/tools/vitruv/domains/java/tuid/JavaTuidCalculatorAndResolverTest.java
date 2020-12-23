package tools.vitruv.domains.java.tuid;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.ConsoleAppender;
import org.apache.log4j.Logger;
import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.emftext.language.java.JavaPackage;
import org.emftext.language.java.classifiers.Classifier;
import org.emftext.language.java.containers.CompilationUnit;
import org.emftext.language.java.containers.Package;
import org.emftext.language.java.members.Member;
import org.emftext.language.java.members.Method;
import org.emftext.language.java.resource.java.mopp.JavaResourceFactory;
import org.emftext.language.java.statements.ExpressionStatement;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;

import tools.vitruv.framework.util.datatypes.VURI;
import static tools.vitruv.domains.java.JavaNamespace.*;

public class JavaTuidCalculatorAndResolverTest {

	private static final Logger logger = Logger.getLogger(JavaTuidCalculatorAndResolverTest.class.getSimpleName());

	private EObject jaMoPPCompilationUnit;
	private EObject jaMoPPPackage;
	private JavaTuidCalculatorAndResolver jamoppTuidCR;
	private VURI compUnitUri;
	private VURI packageUri;

	@BeforeEach
	public void setUp() throws Exception {
		this.jamoppTuidCR = new JavaTuidCalculatorAndResolver();
		Logger.getRootLogger().addAppender(new ConsoleAppender());
		registerMetamodels();

		// create new ResourceSet
		final ResourceSet resSet = new ResourceSetImpl();

		this.compUnitUri = VURI
				.getInstance("MockupProject/src-test/TestCodeForJaMoPPTuidCalculatorAndResolverTest.java");
		this.jaMoPPCompilationUnit = this.getRootJaMoPPObjectFromURIStr(resSet, this.compUnitUri);
		this.packageUri = VURI.getInstance("MockupProject/src-test/package-info.java");
		this.jaMoPPPackage = this.getRootJaMoPPObjectFromURIStr(resSet, this.packageUri);
	}

	/**
	 * Register JaMoPP, PCM and Correspondence packages to use these models in a
	 * non-Plugin test.
	 */
	public static void registerMetamodels() {
		final Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		final Map<String, Object> m = reg.getExtensionToFactoryMap();

		// register JaMoPP package and factory globally
		EPackage.Registry.INSTANCE.put(JavaPackage.eNS_URI, JavaPackage.eINSTANCE);
		m.put(FILE_EXTENSION, new JavaResourceFactory());
		m.put("xmi", new XMIResourceFactoryImpl());
	}

	public EObject getRootJaMoPPObjectFromURIStr(final ResourceSet resSet, final VURI uri) {
		// create new Resource
		final Resource jaMoPPResource = resSet.getResource(uri.getEMFUri(), true);

		// get Repository from resource
		return jaMoPPResource.getContents().get(0);
	}

	@Disabled("Tests are not working because of missing/lost MockupProject")
	@Test
	public void testGetTuid() {
		final CompilationUnit cu = (CompilationUnit) this.jaMoPPCompilationUnit;
		logger.info(
				"Tuid for comilationUnit '" + cu.getName() + "': " + this.jamoppTuidCR.calculateTuidFromEObject(cu));
		for (final Classifier classifier : cu.getClassifiers()) {
			logger.info("Tuid for classifier '" + classifier.getName() + "': "
					+ this.jamoppTuidCR.calculateTuidFromEObject(classifier));
			for (final Member member : classifier.getAllMembers(null)) {
				logger.info("Tuid for member '" + member.toString() + "': "
						+ this.jamoppTuidCR.calculateTuidFromEObject(member));
			}
		}
	}

	@Disabled("Tests are not working because of missing/lost MockupProject")
	@Test
	public void testGetTuidFromPackage() {
		final org.emftext.language.java.containers.Package pack = (org.emftext.language.java.containers.Package) this.jaMoPPPackage;
		logger.info("Tuid for package  '" + pack.getName() + "' : " + this.jamoppTuidCR.calculateTuidFromEObject(pack));
	}

	@Disabled("Tests are not working because of missing/lost MockupProject")
	@Test
	public void testGetIdentifiedPackage() {
		// create Tuids from JaMoPP root
		final org.emftext.language.java.containers.Package pack = (Package) this.jaMoPPPackage;
		final String tuidPackage = this.jamoppTuidCR.calculateTuidFromEObject(pack);

		// reparse java file
		final ResourceSet newResourceSet = new ResourceSetImpl();

		// find Tuids in new java file
		final VURI vuri = VURI.getInstance(this.jamoppTuidCR.getModelVURIContainingIdentifiedEObject(tuidPackage));
		logger.info(vuri);
		final Resource newJaMoPPResource = newResourceSet.getResource(vuri.getEMFUri(), true);
		final EObject newRootEObject = newJaMoPPResource.getContents().get(0);
		final EObject newPack = this.jamoppTuidCR.resolveEObjectFromRootAndFullTuid(newRootEObject, tuidPackage);
		logger.info("New Package: " + newPack);
	}

	@Disabled("Tests are not working because of missing/lost MockupProject")
	@Test
	public void testGetIdentifiedEObject() {
		// create Tuids from JaMoPP root
		final CompilationUnit cu = (CompilationUnit) this.jaMoPPCompilationUnit;
		final String tuidCu = this.jamoppTuidCR.calculateTuidFromEObject(cu);
		final List<String> classifierTuids = new ArrayList<String>();
		final List<String> methodTuids = new ArrayList<String>(16);
		for (final Classifier classifier : cu.getClassifiers()) {
			classifierTuids.add(this.jamoppTuidCR.calculateTuidFromEObject(classifier));
			for (final Member member : classifier.getAllMembers(cu)) {
				if (member instanceof Method) {
					methodTuids.add(this.jamoppTuidCR.calculateTuidFromEObject(member));
				}
			}
		}

		// reparse java file
		final ResourceSet newResourceSet = new ResourceSetImpl();
		final Resource newJaMoPPResource = newResourceSet.getResource(this.compUnitUri.getEMFUri(), true);
		final EObject newRootEObject = newJaMoPPResource.getContents().get(0);

		// find Tuids in new java file
		final VURI vuri = VURI.getInstance(this.jamoppTuidCR.getModelVURIContainingIdentifiedEObject(tuidCu));
		System.out.println(vuri);
		final EObject newCompilationUnit = this.jamoppTuidCR.resolveEObjectFromRootAndFullTuid(newRootEObject, tuidCu);
		System.out.println("New Compilation unit: " + newCompilationUnit);
		for (final String classifierTuid : classifierTuids) {
			System.out.println("Classifier for classifier with tuid " + classifierTuid + ": "
					+ this.jamoppTuidCR.resolveEObjectFromRootAndFullTuid(newRootEObject, classifierTuid));
		}
		for (final String methodTuid : methodTuids) {
			System.out.println("Method for method with tuid " + methodTuid + ": "
					+ this.jamoppTuidCR.resolveEObjectFromRootAndFullTuid(newRootEObject, methodTuid));
		}
	}

	@Disabled("Tests are not working because of missing/lost MockupProject")
	@Test
	public void testExpressionStatement() {
		final List<ExpressionStatement> expressionStatements = this.findUsageOfClass(ExpressionStatement.class);
		assertTrue(0 < expressionStatements.size(), "No expression statement found");
		final List<String> expressionStatementsTuids = new ArrayList<String>();
		for (final ExpressionStatement expressionStatement : expressionStatements) {
			final String currentTuid = this.jamoppTuidCR.calculateTuidFromEObject(expressionStatement);
			expressionStatementsTuids.add(currentTuid);
		}

		final List<ExpressionStatement> foundExpressionStatements = new ArrayList<ExpressionStatement>();
		for (final String expressoinStatementTuid : expressionStatementsTuids) {
			final VURI containingFile = VURI
					.getInstance(this.jamoppTuidCR.getModelVURIContainingIdentifiedEObject(expressoinStatementTuid));
			final ResourceSet resourceSet = new ResourceSetImpl();
			final Resource jaMoPPResource = resourceSet.getResource(containingFile.getEMFUri(), true);
			final EObject rootEObject = jaMoPPResource.getContents().get(0);
			final EObject eObject = this.jamoppTuidCR.resolveEObjectFromRootAndFullTuid(rootEObject,
					expressoinStatementTuid);
			assertTrue(eObject instanceof ExpressionStatement, "eObject is not an instanceof expression statement");
			foundExpressionStatements.add((ExpressionStatement) eObject);
		}

		assertEquals(expressionStatements.size(), foundExpressionStatements.size(),
				"Wrong number of expression statements found");
	}

	@SuppressWarnings("unchecked")
	private <T> List<T> findUsageOfClass(final Class<T> type) {
		final List<T> expressionStatements = new ArrayList<T>();
		final TreeIterator<Object> eObjects = EcoreUtil.getAllContents(this.jaMoPPCompilationUnit, false);
		while (eObjects.hasNext()) {
			final Object eObject = eObjects.next();
			if (type.isInstance(eObject)) {
				expressionStatements.add((T) eObject);
			}
		}
		return expressionStatements;
	}
}
