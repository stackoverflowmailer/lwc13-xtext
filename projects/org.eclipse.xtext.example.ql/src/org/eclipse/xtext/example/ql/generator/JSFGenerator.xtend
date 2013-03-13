package org.eclipse.xtext.example.ql.generator

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.example.ql.qlDsl.ConditionalQuestionGroup
import org.eclipse.xtext.example.ql.qlDsl.Form
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.example.ql.qlDsl.Questionnaire
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import java.util.List

class JSFGenerator implements IGenerator{
	@Inject extension QlInfo 
	@Inject extension JsfOutputConfigurationProvider
 
	override doGenerate(Resource input, IFileSystemAccess fsa) {
        if (input.URI.fileExtension!="ql")
            return
         
        //generate forms
        val questionnaire = input.contents.head as Questionnaire
        for (form: questionnaire.forms) {
            val content = generate_JSFPage(form)
            val fileName = "forms/"+form.name+".xhtml"
            fsa.generateFile(fileName,WEB_CONTENT, content)
        }
        
        //generate index page with links to generated forms
        val contentIndex  = generate_JSFIndexPage(questionnaire.forms)
        fsa.generateFile("form_index.xhtml",WEB_CONTENT, contentIndex)
        
        //generate the bean configuration for generated forms
        val contentConfig  = generate_JSFFacesConfig(questionnaire.forms)
        fsa.generateFile("form_config.xml",WEB_INF, contentConfig)
        
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
				default : '''«generateQuestionText(question)»'''
			}
	}
	
	def generateQuestionBoolean(Question question) {
		'''<h:selectBooleanCheckbox id="«question.id»" value="#{«question.formName+'.'+question.name»}">
				<f:ajax render="«question.referingElementIds»"/>"
			</h:selectBooleanCheckbox>'''}
	
	def generateQuestionText(Question question) {
		'''<h:inputText id="txt«question.id»" value="#{«question.formName+'.'+question.name»}">
				<f:ajax event="keyup" render="«question.referingElementIds»"/>"
			<h:inputText/>'''
	}
	
	
    def generate_JSFFacesConfig(List<Form> forms)
    '''<?xml version="1.0" encoding="UTF-8"?>
    <!-- @generated -->
    <faces-config
       xmlns="http://java.sun.com/xml/ns/javaee"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-facesconfig_2_1.xsd"
       version="2.1">
       «FOR elem : forms»
           <managed-bean>
              <managed-bean-name>«elem.name.toFirstLower»</managed-bean-name>
              <managed-bean-class>forms.«elem.name»</managed-bean-class>
              <managed-bean-scope>session</managed-bean-scope>
           </managed-bean>
                «ENDFOR»
    </faces-config>
    '''
    
    def generate_JSFIndexPage (List<Form> forms)
    '''<?xml version='1.0' encoding='UTF-8' ?>
       <!-- @generated -->
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml"
                xmlns:h="http://java.sun.com/jsf/html"
                xmlns:ui="http://java.sun.com/jsf/facelets">
            <ui:composition template="/index.xhtml">
                <ui:define name="content">      
                «FOR elem: forms SEPARATOR "<br/>"»
                    <h:outputLink value="forms/«elem.name».jsf">«elem.name»</h:outputLink>
                «ENDFOR»
                </ui:define>
            </ui:composition>
            </html>'''
}

