package org.eclipse.xtext.example.ql.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.example.ql.qlDsl.ConditionalQuestionGroup
import org.eclipse.xtext.example.ql.qlDsl.Form
import org.eclipse.xtext.example.ql.qlDsl.FormElement
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.example.ql.qlDsl.Questionnare
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.emf.ecore.EObject
import javax.inject.Inject
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.xbase.XFeatureCall

class JSFGenerator implements IGenerator{
	@Inject extension IJvmModelAssociations

	override doGenerate(Resource input, IFileSystemAccess fsa) {
		if (input.URI.fileExtension!="ql")
			return
		
		val questionnaire = input.contents.head as Questionnare
		for (form: questionnaire.forms) {
			val content = generate_JSFPage(form)
			val fileName = "WebContent/generated/forms/"+form.name+".xhtml"
			fsa.generateFile(fileName, content)
		}
		
			//TODO generate index.xhtml (referencing default layout, can be used in forms)
			//TODO generate faces-config (entry per form)
			//TODO generate web.xml (naming patterns for jsf request)
			//TODO generate defaultLayout (WebContent/resources/default/(css|img||templates))
		
	}
	
	
	def getTextInputPrefixed(String name){'''
		in«name»
	'''
		
	}
	def getCheckBoxPrefixed(String name){'''
		chk«name»
	'''
	}
	
	def generateQuestion(Question question){
'''
		<!-- generateQuestion «question.name» «question.type» (SimpleName: «question.type.simpleName»)-->
			<h:outputLabel value="«question.label»" />
			'''+
			if (question.type.simpleName == "boolean"){
				'''«generateQuestionBoolean(question)»'''
			}else if (question.type.simpleName == "Money"){
				'''«generateQuestionMoney(question)»'''
			}
			+ '''<!-- end generateQuestion «question.name» «question.type» (SimpleName: «question.type.simpleName») -->
			<!-- «question.getDependentElementsWithExpression.map[id]» -->
			'''
			}

			
	
	def generateQuestionBoolean(Question question){'''
				<h:selectBooleanCheckbox id="«getCheckBoxPrefixed(question.name)»"
						value="#{«getFormName(question)».«question.name»}">
						<f:ajax execute="«getCheckBoxPrefixed(question.name)»"
							«getUpdateConditionalQuestionRenderAttribute(question)»/>
					</h:selectBooleanCheckbox>
					<br />
					<!-- «question.getDependentElementsWithExpression.map[id]» -->
					'''}
	
	//TODO Money type?
	def generateQuestionMoney(Question question){'''					
							<h:inputText id="«getTextInputPrefixed(question.name)»"
								value="#{«getFormName(question)».«question.name».amount}">
								<f:ajax event="keyup" execute="«getTextInputPrefixed(question.name)»"
									«getUpdateConditionalQuestionRenderAttribute(question)» />
							</h:inputText>
							<br />
'''
	}
	
	
	
	//TODO wenn keine ConditionalQuestionGroup abhängig dann garnichts
	def getUpdateConditionalQuestionRenderAttribute(Question question){'''render="«getConditionalQuestionSectionId(question)»"'''
	}
	
	//TODO in allen ConditionalQuestionGroup, wenn expression.parts.contains.question.name, dann return (ConditionalQuestionGroup.parts, seperator _,as String id for ajax rendering)		
	//TODO ajax support, ids to render on change, sample: grp_state grp_ValueReside
	def getConditionalQuestionSectionId(Question question){
		'''COND_ID_	«for (condQuestion: question.eContainer.eContents.filter(typeof(ConditionalQuestionGroup))) {condQuestion.condition}»'''
		
	}
	
	def String getId (EObject o) {
		switch (o) {
			Question: o.name
			ConditionalQuestionGroup: "grp"+allConditionalGroups(o).indexOf(o)
		}
	}
	
	def Iterable<FormElement> getDependentElementsWithExpression (Question q) {
		val JvmField field = q.jvmElements.filter(typeof(JvmField)).head
		
		val Iterable<FormElement> allFormElementsWithExpression = field.eResource.allContents.filter(typeof(FormElement)).filter[it.expression!=null].toIterable
		val result = allFormElementsWithExpression.filter[
				val featureCalls = it.expression.eAllContents.filter(typeof(XFeatureCall))
				featureCalls.exists[feature==field]
		].toSet
		return result
		// val crossref = field.eCrossReferences
		// val expressionsReferringTheQuestion = field.eCrossReferences.filter[it instanceof XExpression]
		
		// expressionsReferringTheQuestion.map[EcoreUtil2::getContainerOfType(it, typeof(FormElement))].toSet	
	}
	
	def getExpression (FormElement elem) {
		switch (elem) {
			Question: elem.expression
			ConditionalQuestionGroup: elem.condition
		}
	}
	
	def private allConditionalGroups (EObject ctx) {
		ctx.eResource.allContents.filter(typeof(ConditionalQuestionGroup)).toList
	}
	
	def generateConditionalQuestionGroup(ConditionalQuestionGroup conditionalQuestionGroup)'''
		<!-- B E G I N _ generateConditionalQuestionGroup_ S E C T I O N  -->
					<!-- rendering will be triggered by components bounded to conditions which are used in expressions (group0Visible = box1HouseOwning.hasSoldHouse && box1HouseOwning.hasBoughtHouse)-->
					<h:panelGroup id="grp_hasSoldHouse_hasBoughtHouse">
						<!-- evaluation part, every expression has one -->
						<h:panelGroup id="grp_group0Visible"
							rendered="#{box1HouseOwning.groupHasSoldHouseAndHasBoughtHouseVisible}">
		«FOR i:0..conditionalQuestionGroup.element.size-1»
			«generateQuestionElement(conditionalQuestionGroup.element.get(i))»
		«ENDFOR»
						</h:panelGroup>
					</h:panelGroup>
		<!-- E N D _ generateConditionalQuestionGroup _ S E C T I O N  -->
		
	'''
	
	
	def getFormName(Question question){//TODO get form.name
		'''Box1HouseOwning'''}
	

	
	def generateQuestionElement(FormElement questioNElement){
	switch questioNElement{
		Question : generateQuestion(questioNElement)
		ConditionalQuestionGroup : generateConditionalQuestionGroup(questioNElement)
		default : '''generateQuestionElement QuestionElement «questioNElement.eClass»'''
	}
	}
	 //TODO extract dynamic content
	def generate_JSFPage (Form form) '''
	<!-- @generated -->
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
	xmlns:ui="http://java.sun.com/jsf/facelets"
	xmlns:h="http://java.sun.com/jsf/html"
	xmlns:f="http://java.sun.com/jsf/core">

<ui:composition template="/index.xhtml">

	<ui:define name="content">

		<h:form id="«form.name.toFirstLower»Form">
	 	<!-- B E G I N _ generate_JSFPage _ S E C T I O N  -->
			<h:panelGroup id="grp«form.name»Form">
				<!-- evaluation part, every expression has one -->
				<h:panelGroup id="grp«form.name»Form_nested">
		
		«FOR i:0..form.element.size-1»
			«generateQuestionElement(form.element.get(i))»
		«ENDFOR»
				</h:panelGroup>
			</h:panelGroup>
			<!-- E N D _ generate_JSFPage _ S E C T I O N  -->
		</h:form>
	</ui:define>


</ui:composition>
</html>
	'''
}
