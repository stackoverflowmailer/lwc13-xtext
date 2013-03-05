package org.eclipse.xtext.example.ql.generator

import javax.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.example.ql.qlDsl.ConditionalQuestionGroup
import org.eclipse.xtext.example.ql.qlDsl.Form
import org.eclipse.xtext.example.ql.qlDsl.FormElement
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.example.ql.qlDsl.Questionnaire
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.common.types.util.TypeReferences

/* provides methods for getting needed info from model (e.g. element ids) */
class QlInfo {
	@Inject extension IJvmModelAssociations 

	
		//TODO should return a list of ConditionalQuestionGroupIds where the given question is used by its expression 
	def String getReferingElementIds(Question question) {
		'''«FOR element : getDependentElementsWithExpression(question) SEPARATOR ' '»
         «getId(element)»
       	«ENDFOR»
		'''
	}
	
	def String getId (EObject o) {
		switch (o) {
			Question: "q"+o.name.toFirstUpper
			Form: "form"+o.name.toFirstUpper
			ConditionalQuestionGroup: "group"+allConditionalGroups(o).indexOf(o)
		}
	}
	
	def private allConditionalGroups (EObject ctx) {
		ctx.eResource.allContents.filter(typeof(ConditionalQuestionGroup)).toList
	}

	//TODO will be used in render attribute of jsf:ajax tag of question answer elements to refresh depending conditional parts
	def getConditionalGroupRenderingTriggerId(ConditionalQuestionGroup group) {
		getId(group)}

	//TODO this id is used for the element which implements ConditionalQuestionGroups. it should just be human readable and is not used for mappings currently
	def getConditionalGroupRenderingId(ConditionalQuestionGroup group) {
		'''grp_«group.id»Visible'''}
		
	//TODO this condition will be added to the render attribute for ConditionalQuestionGroup elements
	def getConditionalGroupRenderingCondition(ConditionalQuestionGroup group) {
		'''#{«getFormName(group)».«getConditionalGroupVisibleFeatureId(group)»}'''}
	
	//TODO the bean feature (boolean) name that implements the expression for ConditionalQuestionGroup visibility,
	def getConditionalGroupVisibleFeatureId(ConditionalQuestionGroup group) {
		'''«getId(group)»Visible'''}
		
    //TODO isNaive = true, 
    def getFormName(Question question){'''«(question.eContainer as Form).name.toFirstLower»'''}
    def getFormName(ConditionalQuestionGroup questionGroup){'''«(questionGroup.eContainer as Form).name.toFirstLower»'''}
	
	
	def Iterable<FormElement> getDependentElementsWithExpression (Question q) {
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
		
}