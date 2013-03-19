package org.eclipse.xtext.example.ql

import javax.inject.Inject
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.example.ql.qlDsl.FormElement
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.example.ql.qlDsl.ConditionalQuestionGroup

class QlDslExtensions {
	@Inject extension IJvmModelAssociations

	def Iterable<FormElement> getDependentElementsWithExpression (Question q) {
	  if (q.expression != null)
	   return emptyList
	   
		val JvmField field = q.jvmElements.filter(typeof(JvmField)).head
		  
		val Iterable<FormElement> allFormElementsWithExpression = field.eResource.allContents.filter(typeof(FormElement)).filter[it.expression!=null].toIterable
		val result = allFormElementsWithExpression.filter[
				val featureCalls = it.expression.eAllContents.filter(typeof(XFeatureCall))
				featureCalls.exists[feature==field]
		].toSet
		return result
	}
	
	def getExpression (FormElement elem) {
		switch (elem) {
			Question: elem.expression
			ConditionalQuestionGroup: elem.condition
		}
	}
	
	/**
	 * Returns the JvmField that was inferred from the Question element
	 */
	def getJvmField (Question q) {
		q.jvmElements.filter(typeof(JvmField)).head
	}
	
}