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

class JSFGenerator implements IGenerator{
	@Inject extension IJvmModelAssociations
	@Inject TypeReferences typeReferences
	
	@Inject QlInfo info
	@Inject JSFTag tag

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
«tag.docType()»
«tag.opHtml(true,true,true)»

«tag.opComposition("/index.xhtml")»
	«tag.opDefine("content")»
		«tag.opForm(form.name)»
	 	<!-- B E G I N _ generate_JSFPage _ S E C T I O N  -->
			<h:panelGroup id="grp«form.name»Form">
				<!-- evaluation part, every expression has one -->
				<h:panelGroup id="grp«form.name»Form_nested">
		«FOR i:0..form.element.size-1»
			«generateQuestionElement(form.element.get(i))»
		«ENDFOR»
				«tag.clPanelGroup()»
			«tag.clPanelGroup()»
			<!-- E N D _ generate_JSFPage _ S E C T I O N  -->
		«tag.clForm()»
	«tag.clDefine()»
«tag.clComposition()»
«tag.clHtml()»
	'''
	
	def generateQuestionElement(FormElement formElement){
		switch formElement{
			Question : generateQuestion(formElement)
			ConditionalQuestionGroup : generateConditionalQuestionGroup(formElement)
			default : '''UNKNOWN generateQuestionElement QuestionElement «formElement.eClass»'''
	}
	}
	
	//TODO in allen ConditionalQuestionGroup, wenn expression.parts.contains.question.name, dann return (ConditionalQuestionGroup.parts, seperator _,as String id for ajax rendering)		
	//TODO ajax support, ids to render on change, sample: grp_state grp_ValueReside
	
	def generateConditionalQuestionGroup(ConditionalQuestionGroup conditionalQuestionGroup)
				'''<h:panelGroup id="«info.getConditionalGroupRenderingTriggerId(conditionalQuestionGroup)»">
						<h:panelGroup id="«info.getConditionalGroupRenderingId(conditionalQuestionGroup)»"
							rendered="«info.getConditionalGroupRenderingCondition(conditionalQuestionGroup)»">
						«FOR i:0..conditionalQuestionGroup.element.size-1»
								«generateQuestionElement(conditionalQuestionGroup.element.get(i))»
						«ENDFOR»
						«tag.clPanelGroup()»
					«tag.clPanelGroup()»'''

	//TODO a cleaner solution for providing extensibility of question types? 
	//TODO special cases (readonly money, )
	def generateQuestion(Question question){
		'''«tag.opOutputLabel(question.name,question.label,true)»
			'''+
			switch(question.type.simpleName){
				case 'boolean': '''«generateQuestionBoolean(question)»'''
				case "Money" : '''«generateQuestionMoney(question)»'''
				default: '''UNKNOWN Question type : '''+question.type.simpleName
			}
	}
	
	def generateQuestionBoolean(Question question){
				'''<h:selectBooleanCheckbox id="«JSFConvention::prefixCheck(question.name)»"
						value="#{«getBooleanValueExpression(question)»}">
						«getAjaxUpdate(null,info.getReferingElementIds(question))»
					</h:selectBooleanCheckbox>'''}
	
	def generateQuestionMoney(Question question){					
	'''«tag.opInputText(question.name,getMoneyValueExpression(question),false)»
			«getAjaxUpdate('keyup',info.getReferingElementIds(question))»
		«tag.clInputText()»'''
	}
	
	//TODO beanName.featureName.(amount?)
	def String getMoneyValueExpression(Question question) {
		info.getFormName(question)+'.'+question.name+'.amount'
	}
		//TODO beanName.featureName.(amount?)
	def String getBooleanValueExpression(Question question) {
		info.getFormName(question)+'.'+question.name
	}
		//TODO beanName.featureName.(amount?)
	def String getTextValueExpression(Question question) {
		info.getFormName(question)+'.'+question.name+'.amount'
	}

	/**
	 * @param onEvent the event which executes a the clients request
	 * @param renderedElements IDs of elements that will be rendered after response
	 */
	def getAjaxUpdate(String onEvent,String renderedElements) {
			tag.getAjaxSupport(onEvent,null,renderedElements)
	}
}

