package tools.vitruv.domains.java.tuid

import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.emftext.language.java.classifiers.Classifier
import org.emftext.language.java.containers.CompilationUnit
import org.emftext.language.java.containers.JavaRoot
import org.emftext.language.java.containers.Package
import org.emftext.language.java.expressions.AssignmentExpression
import org.emftext.language.java.expressions.ConditionalExpression
import org.emftext.language.java.imports.Import
import org.emftext.language.java.imports.StaticImport
import org.emftext.language.java.instantiations.NewConstructorCall
import org.emftext.language.java.literals.This
import org.emftext.language.java.members.Constructor
import org.emftext.language.java.members.Field
import org.emftext.language.java.members.Method
import org.emftext.language.java.modifiers.Modifier
import org.emftext.language.java.operators.Assignment
import org.emftext.language.java.parameters.Parameter
import org.emftext.language.java.references.IdentifierReference
import org.emftext.language.java.references.SelfReference
import org.emftext.language.java.statements.ExpressionStatement
import org.emftext.language.java.types.ClassifierReference
import org.emftext.language.java.types.NamespaceClassifierReference
import org.emftext.language.java.types.PrimitiveType
import tools.vitruv.framework.tuid.HierarchicalTuidCalculatorAndResolver
import static tools.vitruv.domains.java.JavaNamespace.*
import org.emftext.language.java.references.StringReference
import org.emftext.language.java.classifiers.Annotation
import org.emftext.language.java.members.EnumConstant
import org.emftext.language.java.annotations.AnnotationInstance
import org.emftext.language.java.statements.Return
import org.emftext.language.java.literals.Literal
import org.emftext.language.java.expressions.Expression
import org.emftext.language.java.operators.Operator
import org.emftext.language.java.classifiers.AnonymousClass
import org.emftext.language.java.members.EmptyMember
import org.emftext.language.java.statements.Statement
import org.emftext.language.java.variables.Variable
import org.emftext.language.java.generics.TypeArgument
import org.emftext.language.java.statements.StatementListContainer
import org.emftext.language.java.arrays.ArrayDimension
import org.emftext.language.java.arrays.ArrayInitializer
import org.emftext.language.java.arrays.ArraySelector
import org.emftext.language.java.annotations.SingleAnnotationParameter
import org.emftext.language.java.references.ReferenceableElement

/**
 * Tuid calculator and resolver for the JaMoPP meta-model. 
 */
class JavaTuidCalculatorAndResolver extends HierarchicalTuidCalculatorAndResolver<JavaRoot> {

	private val static Logger logger = Logger.getLogger(JavaTuidCalculatorAndResolver);

	private val String PARAMETER_SELECTOR = "parameter"
	private val String CLASSIFIER_SELECTOR = "classifier"
	private val String IMPORT_SELECTOR = "import"
	private val String METHOD_SELECTOR = "method"
	private val String FIELD_SELECTOR = "field"
	private val String CONSTRUCTOR_SELECTOR = "constructor"
	private val String ASSIGNMENT_EXPRESSION_SELECTOR = "assignmentExpression"
	private val String EXPRESSION_STATEMENT_SELECTOR = "expressionStatement"
	private val String SELF_REFERENCE_SELECTOR = "selfReference"
	private val String STRING_REFERENCE_SELECTOR = "StringReference"
	private val String IDENTIFIER_REFERENCE_SELECTOR = "identifierReference"
	private val String NEW_CONSTRUCTOR_CALL_SELECTOR = "newConstructorCall"
	private val String CONDITIONAL_EXPRESSION_SELECTOR = "conditionalExpression"
	
	new() {
		super(METAMODEL_NAMESPACE)
	}

	// ============================================================================
	// Base class stuff
	// ============================================================================

	override protected Class<JavaRoot> getRootObjectClass() {
		return JavaRoot
	}

	override protected hasId(EObject obj, String indidivualId) throws IllegalArgumentException {
		return obj.calculateIndividualTuid == indidivualId
	}

	override protected String calculateIndividualTuidDelegator(EObject obj) {
		return obj.calculateIndividualTuid
	}

	// ============================================================================
	// Tuid generation
	// ============================================================================
	private def dispatch String calculateIndividualTuid(Package jaMoPPPackage) {
		return ""
	}

	private def dispatch String calculateIndividualTuid(CompilationUnit compilationUnit) {
		return ""

	//		var String className = null;
	//
	//		/**
	//         * if compilation.getName == null (which can happen) we use the name of the first classifier
	//         * in the compilation unit as name. If there are no classifiers in the compilation unit we
	//         * use <null> as name
	//         */
	//		if (null != compilationUnit.getName()) {
	//			className = compilationUnit.getName();
	//		} else if (0 != compilationUnit.getClassifiers().size()) {
	//			className = compilationUnit.getClassifiers().get(0).getName() + ".java";
	//		} else {
	//			logger.warn("Could not determine a name for compilation unit: " + compilationUnit);
	//		}
	//		val boolean alreadyContainsNamespace = (1 < StringUtils.countMatches(className, "."));
	//		if(alreadyContainsNamespace){
	//			return className;
	//		}
	//		return getNamespaceAsString(compilationUnit) + "." + className;
	}

	private def dispatch String calculateIndividualTuid(Classifier classifier) {
		return CLASSIFIER_SELECTOR + SUBDIVIDER + classifier.getName()
	}

	private def dispatch String calculateIndividualTuid(Method method) {
		val tuid = new StringBuilder()
		tuid.append(METHOD_SELECTOR)
		tuid.append(SUBDIVIDER + getNameFrom(method.typeReference) + SUBDIVIDER + method.name)
		method.parameters.forEach[tuid.append(SUBDIVIDER + getNameFrom(typeReference))]
		return tuid.toString
	}

	private def dispatch String calculateIndividualTuid(Field field) {
		return FIELD_SELECTOR + SUBDIVIDER + field.name
	}

	private def dispatch String calculateIndividualTuid(Import importStatement) {
		var tuid = IMPORT_SELECTOR
		if (importStatement instanceof StaticImport) {
			tuid += "static" + SUBDIVIDER
		}
		return tuid + JamoppStringOperations.getStringRepresentation(importStatement)
	}

	private def dispatch String calculateIndividualTuid(Modifier modifier) {
		return modifier.class.interfaces.get(0).simpleName;
	}

	private def dispatch String calculateIndividualTuid(Parameter param) {
		return PARAMETER_SELECTOR + SUBDIVIDER + param.name
	}

	private def dispatch String calculateIndividualTuid(NamespaceClassifierReference ref) {
		val tuid = new StringBuilder()
		// If the reference was removed from the model, the containing feature is null.
		// Omit it in the Tuid then
		if (ref.eContainingFeature !== null) {
			tuid.append(ref.eContainingFeature.name)
		}
		ref.classifierReferences.forEach[tuid.append(target?.name)]
		return tuid.toString
	}

	private def dispatch String calculateIndividualTuid(PrimitiveType pt) {
		return pt.class.interfaces.get(0).simpleName
	}

	private def dispatch String calculateIndividualTuid(Constructor constuctor) {
		val tuid = new StringBuilder
		tuid.append(CONSTRUCTOR_SELECTOR).append(SUBDIVIDER).append(constuctor.name)
		constuctor.parameters.forEach[tuid.append(SUBDIVIDER + getNameFrom(typeReference))]
		return tuid.toString
	}

	private def dispatch String calculateIndividualTuid(ExpressionStatement expressionStatement) {
		val tuid = new StringBuilder
		tuid.append(EXPRESSION_STATEMENT_SELECTOR).append(SUBDIVIDER);
		tuid.append(expressionStatement.expression.calculateIndividualTuid);
		return tuid.toString
	}

	private def dispatch String calculateIndividualTuid(AssignmentExpression assignmentExpression) {
		val tuid = new StringBuilder
		tuid.append(ASSIGNMENT_EXPRESSION_SELECTOR).append(SUBDIVIDER)
		if (null !== assignmentExpression.child) {
			tuid.append(assignmentExpression.child.calculateIndividualTuid).append(SUBDIVIDER)
		}
		if (null !== assignmentExpression.assignmentOperator) {
			tuid.append(assignmentExpression.assignmentOperator.calculateIndividualTuid).append(SUBDIVIDER)
		}
		if (null !== assignmentExpression.value) {
			tuid.append(assignmentExpression.value.calculateIndividualTuid)
		}
		return tuid.toString
	}

	private def dispatch String calculateIndividualTuid(SelfReference selfReference) {
		val tuid = new StringBuilder
		tuid.append(SELF_REFERENCE_SELECTOR)
		tuid.append(selfReference.self.calculateIndividualTuid).append(SUBDIVIDER)
		tuid.append(selfReference.next.calculateIndividualTuid)
		return tuid.toString
	}
	
	private def dispatch String calculateIndividualTuid(StringReference stringReference) {
        val tuid = new StringBuilder
        tuid.append(STRING_REFERENCE_SELECTOR)
        tuid.append(stringReference.value)
        return tuid.toString
    }
    private def dispatch String calculateIndividualTuid(Annotation annotation) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(EnumConstant constant) {
        val tuid = new StringBuilder()
        tuid.append(constant.name)
        
        return tuid.toString
    }
    
    private def dispatch String calculateIndividualTuid(AnnotationInstance obj) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(Literal literal) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(ArrayDimension arrayDim) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(ArrayInitializer array) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(SingleAnnotationParameter param) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(ReferenceableElement elem) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(ArraySelector array) {
        return ""
    }
    private def dispatch String calculateIndividualTuid(Void nullRef) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(EmptyMember emptyMember) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(Return returnStatement) {
        return ""
    }
    private def dispatch String calculateIndividualTuid(StatementListContainer statementListContainer) {
        return ""
    }
    private def dispatch String calculateIndividualTuid(TypeArgument typeArgument) {
        return ""
    }
    private def dispatch String calculateIndividualTuid(Variable variable) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(Statement statement) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(Expression expression) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(AnonymousClass anonClass) {
        return ""
    }
    
    private def dispatch String calculateIndividualTuid(Operator operator) {
        return ""
    }
	

	private def dispatch String calculateIndividualTuid(This thisRef) {
		return "this"
	}

	private def dispatch String calculateIndividualTuid(IdentifierReference identifierReference) {
		val tuid = new StringBuilder
		tuid.append(IDENTIFIER_REFERENCE_SELECTOR)
		if(null !== identifierReference && null !== identifierReference.target){
			tuid.append(identifierReference.target.name)	
		}
		return tuid.toString
	}

	private def dispatch String calculateIndividualTuid(Assignment assignment) {
		return "="
	}

	private def dispatch String calculateIndividualTuid(NewConstructorCall newConstructorCall) {
		val tuid = new StringBuilder
		tuid.append(NEW_CONSTRUCTOR_CALL_SELECTOR).append(SUBDIVIDER)
		tuid.append(getNameFrom(newConstructorCall.typeReference)).append(SUBDIVIDER)
		return tuid.toString
	}

	// actually we should not need this method. However, JaMoPP sometimes creates a ConditionalExpression instead 
	// of an AssignementExpression. Traverse the childs until the type reference is not null
	private def dispatch String calculateIndividualTuid(ConditionalExpression conditionalExpression) {
		val tuid = new StringBuilder
		tuid.append(CONDITIONAL_EXPRESSION_SELECTOR)
		if (null === conditionalExpression.type) {
			tuid.append(SUBDIVIDER).append("null")
		} else {
			tuid.append(SUBDIVIDER).append(conditionalExpression.type.calculateIndividualTuid)
		}
		return tuid.toString
	}

	private def dispatch String calculateIndividualTuid(ClassifierReference classifierReference) {
		val tuid = new StringBuilder()
		tuid.append(classifierReference.eContainingFeature?.name)
		tuid.append(classifierReference.target?.name)
		return tuid.toString
	}

	private def dispatch String calculateIndividualTuid(EObject obj) {
		throw new IllegalArgumentException("Invalid type given " + obj.class.simpleName);
	}

	// ============================================================================
	// Helpers
	// ============================================================================
	private def dispatch String getNameFrom(NamespaceClassifierReference namespaceClassifierReference) {
		var name = "";
		var int i = 0;
		for (ClassifierReference cr : namespaceClassifierReference.getClassifierReferences()) {
			if (i > 0) {
				name += i
			}
			name += getNameFrom(cr);
			i++;
		}
		return name;
	}

	private def dispatch String getNameFrom(PrimitiveType primitiveType) {
		return primitiveType.eClass().getName().replaceAll("Impl", "");
	}

	private def dispatch String getNameFrom(ClassifierReference classifierReference) {
		return classifierReference.target?.name
	}
	
	private def dispatch String getNameFrom(Void nullType){
		logger.warn("getNameFrom name for "+ nullType + " not possible" )
		return "";
	}

}
