package org.eclipse.xtext.example.ql

import javax.inject.Inject
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.example.ql.qlDsl.FormElement
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.example.ql.qlDsl.ConditionalQuestionGroup
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.example.ql.qlDsl.Form

class QlDslExtensions {
	@Inject extension IJvmModelAssociations

  /**
   * Computes the FormElements which are accessed by the expression of a Question.
   */
  def Iterable<FormElement> getDependentElementsWithExpression (Question q) {
    if (q.expression != null)
      return emptyList
    // The JvmField which is inferred from a Question
    val JvmField field = q.jvmElements.filter(typeof(JvmField)).head
    // Get all FormElements which have an expression 
    val Iterable<FormElement> allFormElementsWithExpression = q.form.eAllContents
      .filter(typeof(FormElement))
      .filter[it.expression!=null]
      .toSet
      
   // search the expressions of the form elements which call the JvmField field in a feature call
   val result = allFormElementsWithExpression.filter[
    	//TODO if there is a 'this' used in the expression, the following logic will fail!
    	val exp = it.expression
    	if (exp instanceof XFeatureCall) {
    		// a simple expression e.g. '(XFeatureCall)'
    		(exp as XFeatureCall).feature.simpleName == field.simpleName	
    	} else {
    		// a complex expression e.g. '(XFeatureCall1 - XFeatureCall2)'
	        val xfeaturecalls = exp.eAllContents.filter(typeof(XFeatureCall))
	        xfeaturecalls.exists[
	        	feature.simpleName == field.simpleName
	        ]
    	}
    
	]
    return result
  }

 /**
  * Creates an id for the given domain object. 
  */
  def String getId (EObject o) {
    switch (o) {
      ConditionalQuestionGroup: "group"+allConditionalGroups(o).indexOf(o)
      Question: o.name
      Form: o.name.toLowerCase
    }
  }
  
  /**
   * Get all ConditionalGroups underneath the given context.
   */
  def private allConditionalGroups (EObject ctx) {
    ctx.form.eAllContents.filter(typeof(ConditionalQuestionGroup)).toList
  }

  /**
   * Get the parent form's name
   */
  def getFormName(FormElement elem){ 
    elem.form.name.toFirstLower
  }

  /**
   * Get the Form container of the given question. 
   */
  def getForm(EObject question) {
	EcoreUtil2::getContainerOfType(question, typeof(Form)) as Form
  }

  /**
   * Returns the expression assigned to a FormElement, dependent on subtype for FormElement. 
   */
  def getExpression (FormElement elem) {
    switch (elem) {
      Question: elem.expression
      ConditionalQuestionGroup: elem.condition
    }
  }
}