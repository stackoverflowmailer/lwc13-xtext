package org.eclipse.xtext.example.ql.generator

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.example.ql.qlDsl.ConditionalQuestionGroup
import org.eclipse.xtext.example.ql.qlDsl.Form
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.example.ql.qlDsl.Questionnaire
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import types.Money

class JSFGenerator implements IGenerator{
	@Inject extension QlInfo info

	override doGenerate(Resource input, IFileSystemAccess fsa) {
		if (input.URI.fileExtension!="ql")
			return
		
		val questionnaire = input.contents.head as Questionnaire
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
					<h:form id="«form.id»">
				 	<!-- B E G I N _ generate_JSFPage _ S E C T I O N  -->
						<h:panelGroup id="grp«form.name»Form">
							<!-- evaluation part, every expression has one -->
							<h:panelGroup id="grp«form.name»Form_nested">
							«FOR elem: form.element»
								«elem.generate»
							«ENDFOR»
							</h:panelGroup>
						</h:panelGroup>
					<!-- E N D _ generate_JSFPage _ S E C T I O N  -->
					</h:form>
				</ui:define>
			</ui:composition>
		</html>
	'''
	
	//TODO in allen ConditionalQuestionGroup, wenn expression.parts.contains.question.name, dann return (ConditionalQuestionGroup.parts, seperator _,as String id for ajax rendering)		
	//TODO ajax support, ids to render on change, sample: grp_state grp_ValueReside
	
	def dispatch generate (ConditionalQuestionGroup conditionalQuestionGroup)
		'''<h:panelGroup id="«conditionalQuestionGroup.id»">
				<h:panelGroup id="«conditionalQuestionGroup.conditionalGroupRenderingId»"
					rendered="«conditionalQuestionGroup.conditionalGroupRenderingCondition»">
				«FOR elem: conditionalQuestionGroup.element»
					«elem.generate»
				«ENDFOR»
				</h:panelGroup>
			</h:panelGroup>'''

	//TODO a cleaner solution for providing extensibility of question types? 
	//TODO special cases (readonly money, )
	def dispatch generate (Question question){
		'''<h:outputLabel id="lbl«question.id»" value="«question.label»/>
			'''+
			switch(question.type){
				case typeof(boolean): '''«generateQuestionBoolean(question)»'''
				case typeof(Money) : '''«generateQuestionMoney(question)»'''
				default: '''UNKNOWN Question type : '''+question.type.simpleName
			}
	}
	
	def generateQuestionBoolean(Question question) {
		'''<h:selectBooleanCheckbox id="«question.id»" value="#{«question.formName+'.'+question.name»}">
				<f:ajax render="«question.referingElementIds»"/>"
			</h:selectBooleanCheckbox>'''}
	
	def generateQuestionMoney(Question question) {
		'''<h:inputText id="txt«question.id»" value="#{«question.formName+'.'+question.name»}">
				<f:ajax event="keyup" render="«question.referingElementIds»"/>"
			<h:inputText/>'''
	}
}

