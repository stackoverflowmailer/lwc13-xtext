package org.eclipse.xtext.example.ql.jvmmodel

import com.google.inject.Inject
import java.io.Serializable
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.example.ql.qlDsl.ConditionalQuestionGroup
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.example.ql.qlDsl.Questionnaire
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.common.types.TypesFactory
import org.eclipse.jdt.annotation.Nullable
import org.eclipse.xtext.common.types.JvmAnnotationReference
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmPrimitiveType

/**
 * <p>Infers a JVM model from the source model.</p>
 *
 * <p>The JVM model should contain all elements that would appear in the Java code
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>
 */
class QlDslJvmModelInferrer extends AbstractModelInferrer {

  /**
   * convenience API to build and initialize JVM types and their members.
   */
  @Inject extension JvmTypesBuilder
  /**
   * Grants access to JVM Types
   */
  @Inject TypeReferences typeReferences
  @Inject TypesFactory typesFactory;

  /**
   * The dispatch method {@code infer} is called for each instance of the
   * given element's type that is contained in a resource.
   *
   * @param element
   *            the model to create one or more
   *            {@link org.eclipse.xtext.common.types.JvmDeclaredType declared
   *            types} from.
   * @param acceptor
   *            each created
   *            {@link org.eclipse.xtext.common.types.JvmDeclaredType type}
   *            without a container should be passed to the acceptor in order
   *            get attached to the current resource. The acceptor's
   *            {@link IJvmDeclaredTypeAcceptor#accept(org.eclipse.xtext.common.types.JvmDeclaredType)
   *            accept(..)} method takes the constructed empty type for the
   *            pre-indexing phase. This one is further initialized in the
   *            indexing phase using the closure you pass to the returned
   *            {@link org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor.IPostIndexingInitializing#initializeLater(org.eclipse.xtext.xbase.lib.Procedures.Procedure1)
   *            initializeLater(..)}.
   * @param isPreIndexingPhase
   *            whether the method is called in a pre-indexing phase, i.e.
   *            when the global index is not yet fully updated. You must not
   *            rely on linking using the index if isPreIndexingPhase is
   *            <code>true</code>.
   */
  def dispatch void infer(Questionnaire element, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
    for (form: element.forms) {
      acceptor.accept(form.toClass("forms."+form.name))
      .initializeLater[
        it.annotations +=  toAnnotation(element,"javax.faces.bean.ManagedBean", "name", form.name.toFirstLower)
        it.annotations +=  toAnnotation(element,"javax.faces.bean.SessionScoped")
        
        //implements Serializable
        it.superTypes +=typeReferences.getTypeForName(typeof(Serializable),element,null)

        members += toField("serialVersionUID",typeReferences.getTypeForName("long",element),[final = true ^static = true 
        	setInitializer([it.append("1L")])
        ])

        // Questions can be either direct in the form, or part of ConditionalQuestionGroup
        // toList: make the collection iterable twice
        val allQuestions = form.eAllContents.filter(typeof(Question)).toList
        // first add fields for all non computed values
        for (question: allQuestions.filter[expression==null]) {
          members += question.toField(question.name, question.type, [
            if (!(question.type.type instanceof JvmPrimitiveType))
              setInitializer([append("types.TypeFactory.create"+question.type.type.simpleName+"()")])
          ])
        }
        // now accessor methods
        for (question: allQuestions) {
          if (question.expression == null) {
            // no computation expression => simple Getter/Setter methods
            members += question.toGetter(question.name, question.type)
            members += question.toSetter(question.name, question.type)
          } else {
            // field value is computed => no Setter, computed getter
            val getter = question.toGetter(question.name, question.type)
            getter.body = question.expression
            members += getter
          }
          members += question.createIsEnabledMethod
        }

        val allQuestionGroups = form.eAllContents.filter(typeof(ConditionalQuestionGroup)).toList
        var groupIndex=0;
        for (questionGroup: allQuestionGroups) {
          members += questionGroup.createIsGroupVisibleMethod(groupIndex)
          groupIndex = groupIndex+1
        }

      ]
    }
  }

  /**
   * Creates and returns an annotation reference of the given annotation type's name.
   * The annotation gets a String value.
   */
  @Nullable
  def JvmAnnotationReference toAnnotation(@Nullable EObject sourceElement, @Nullable String annotationTypeName, String valueName, String value) {
    val annotation = toAnnotation(sourceElement, annotationTypeName)
    val annotationValue = typesFactory.createJvmStringAnnotationValue
    annotationValue.operation = annotation.annotation.declaredOperations.findFirst[simpleName==valueName]
    annotationValue.values += value
    annotation.values += annotationValue    
    return annotation
  }

   /**
    * Create a method <code>public boolean is[QUESTION]Enabled ()</code>.
    * @param question Source Question instance
    */
   def JvmOperation createIsEnabledMethod (Question question) {
     question.toMethod("is"+question.name.toFirstUpper+"Enabled", typeReferences.getTypeForName("boolean", question, null)) [
       body = [it.append('''return «question.expression == null»;''')]
  ]
   }

   /**
    * Create a method <code>public boolean isGroup[groupIndex]Visible ()</code>.
    */
   def JvmOperation createIsGroupVisibleMethod (ConditionalQuestionGroup group, int groupIndex) {
     group.toMethod("isGroup"+groupIndex+"Visible", typeReferences.getTypeForName("boolean", group, null)) [
       if(group.condition != null) {
         body = group.condition
       } else {
         body = [it.append('''return true;''')]
       }
     ]
   }

}

