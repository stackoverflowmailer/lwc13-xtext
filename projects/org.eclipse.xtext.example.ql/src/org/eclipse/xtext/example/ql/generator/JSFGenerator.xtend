package org.eclipse.xtext.example.ql.generator

import java.util.List
import javax.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.common.types.JvmPrimitiveType
import org.eclipse.xtext.example.ql.qlDsl.ConditionalQuestionGroup
import org.eclipse.xtext.example.ql.qlDsl.Form
import org.eclipse.xtext.example.ql.qlDsl.FormElement
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.example.ql.qlDsl.Questionnaire
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import java.util.Set

class JSFGenerator implements IGenerator{
  @Inject extension IJvmModelAssociations
  @Inject extension JSFOutputConfigurationProvider
  
  override doGenerate(Resource input, IFileSystemAccess fsa) {
        if (input.URI.fileExtension!="ql")
            return

        //generate forms
        val questionnaire = input.contents.head as Questionnaire
        for (form: questionnaire.forms) {
        	//simple jsf which includes the generated form
            val content = generate_FormPage(form)
            val fileName = "generated/forms/"+form.name+".xhtml"
            fsa.generateFile(fileName,WEB_CONTENT, content)
            
            //the base form which can be included in other pages
            val contentBase = generate_FormBase(form)
            val fileNameBase = "generated/forms/"+form.name+"Base.xhtml"
            fsa.generateFile(fileNameBase,WEB_CONTENT, contentBase)
        }

        //generate index page with links to generated forms
        val contentIndex  = generate_FormIndex(questionnaire.forms)
        // TODO the generator is called once per resource, so the index page will be overwritten if there is more than model file
        fsa.generateFile("generated/forms/index.xhtml",WEB_CONTENT, contentIndex)

    }
    
    
  def generate_FormBase(Form form)
  '''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	    	
	<!-- @generated -->

	    <html xmlns="http://www.w3.org/1999/xhtml"
	      xmlns:ui="http://java.sun.com/jsf/facelets"
	      xmlns:h="http://java.sun.com/jsf/html"
	      xmlns:f="http://java.sun.com/jsf/core">
	  	 	<h:form id="«form.id»">
	      «FOR elem: form.element»
	        	«elem.generateFormElement»
	      «ENDFOR»
			</h:form>
	    </html>
  '''
    
  def generate_FormPage (Form form) 
  '''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
	<!-- @generated -->
	
    <html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:ui="http://java.sun.com/jsf/facelets"
      xmlns:h="http://java.sun.com/jsf/html"
      xmlns:f="http://java.sun.com/jsf/core">

      <ui:composition template="/index.xhtml">
        <ui:define name="content">
          <ui:include src="«form.name»Base.xhtml" />	
        </ui:define>
      </ui:composition>
    </html>
  '''

  def generate_FormIndex (List<Form> forms)
  '''<?xml version='1.0' encoding='UTF-8' ?>
      <!-- @generated -->
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
      <html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:h="http://java.sun.com/jsf/html"
        xmlns:ui="http://java.sun.com/jsf/facelets">
      <ui:composition template="/index.xhtml">
        <ui:define name="content">
        «FOR elem: forms SEPARATOR "<br/>"»
          <h:outputLink value="«elem.name».jsf">«elem.name»</h:outputLink>
        «ENDFOR»
        </ui:define>
      </ui:composition>
      </html>
  '''
	
  def Object generateFormElement(FormElement element)
  '''<!-- generateFormElement(FormElement element) -->
	«IF element.isReferenced»
		<h:panelGroup id="«element.renderGroupId»">
			<h:panelGroup id="grp_«element.id»Visible"
				rendered="#{«element.formName».«element.id»Visible}">
	«ENDIF»
			 	«element.generate»
	«IF element.isReferenced»
	     	 </h:panelGroup>
	     </h:panelGroup>
	«ENDIF»
	'''

  def dispatch generate(ConditionalQuestionGroup group) 
  '''<!-- generate (ConditionalQuestionGroup group) -->
      «FOR elem: group.element»
        «elem.generateFormElement»
      «ENDFOR»
   '''
   
  def dispatch generate (Question question) 
  '''<!-- generate (Question question) -->
    <h:outputLabel id="lbl«question.id.toFirstUpper»" value="«question.label»"/>
    «switch(question.type.type){
        JvmPrimitiveType: {
          switch (question.type.simpleName.toLowerCase){
            case "boolean": '''		«generateQuestionBoolean(question)»'''
          }
        }
        default : '''		«generateQuestionText(question)»'''
      }»
     <br/>
  '''
	def boolean isReferenced(FormElement element) {
		element.expression != null
	}


  def generateQuestionBoolean(Question question) '''
    <h:selectBooleanCheckbox id="q«question.id»" value="#{«question.formName+'.'+question.name»}">
      <f:ajax event="click" render="«question.getRenderSequence»"/>
    </h:selectBooleanCheckbox>
  '''

  def generateQuestionText(Question question) '''
    <h:inputText id="q_«question.id»" value="#{«question.formName+'.'+question.name»}"«IF question.expression!=null» readonly="true"«ENDIF»>
      <f:ajax event="blur" render="«question.getRenderSequence»"/>
      «generateConverter(question)»
    </h:inputText>
  '''
  
  /**
   * Creates a sequence from all dependent page element ids for the given question.
   */
  def getRenderSequence (Question question) {
     '''«FOR elem: question.dependentElementsWithExpression SEPARATOR ' '»«elem.getRenderGroupId»«ENDFOR»'''
  }
   
  /**
   * 
   */
  def generateConverter (Question question) {
    // primitive types and known classes do not require a special converter
    val needsConversion = !(question.type.type instanceof JvmPrimitiveType) 
       && !defaultConverters.contains(question.type.type.simpleName)
    if (needsConversion) {
      '''<f:converter converterId="converter.«question.type.type.simpleName»"/>'''
    } else
      ""
  }
  
  // enumeration of class names which do not need a converter
  // see http://www.javabeat.net/2007/11/using-converters-in-jsf/
  Set<String> defaultConverters = newHashSet ("BigDecimal","BigInteger",
    "Boolean","Byte","Character","DateTime","Double","Enum","Float","Integer","Long",
    "Number","Short","String"
  )
  
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
 * Creates the id which will be used to trigger updates of parts in the generated JSF page.
 */
  def String getRenderGroupId (EObject elem) {
    switch (elem) {
      Form: "grp_"+elem.id
      ConditionalQuestionGroup: "grp_"+elem.id
      Question : "grp_"+elem.id
    }
  }


/**
 * Get all ConditionalGroups underneath the given context.
 */
  def private allConditionalGroups (EObject ctx) {
    ctx.form.eAllContents.filter(typeof(ConditionalQuestionGroup)).toList
  }

  def getFormName(FormElement elem){ 
    elem.form.name.toFirstLower
  }


  /**
   * Computes the FormElements which are accessed by the expression of a Question.
   */
  def Iterable<FormElement> getDependentElementsWithExpression (Question q) {
    if (q.expression != null)
      return emptyList
    // The JvmField which is inferred from a Question
    val JvmField field = q.jvmElements.filter(typeof(JvmField)).head

    // Get all FormElements which have an expression 
    val form = getForm(q)
    val allFormContents =  org::eclipse::xtend::typesystem::emf::EcoreUtil2::allContents(form)
    val Iterable<FormElement> allFormElementsWithExpression = allFormContents
      .filter(typeof(FormElement))
      .filter[it.expression!=null]
      .toSet
      
   // search the expressions of the form elements which call the JvmField field in a feature call
   val result = allFormElementsWithExpression.filter[
    	//TODO if there is a 'this' used in the expression, the following logic will fail!
    	val exp = it.expression
    	if(exp instanceof XFeatureCall){
    		// a simple expression e.g. '(XFeatureCall)'
    		(exp as XFeatureCall) .feature.simpleName == field.simpleName	
    	}else{
    		// a complex expression e.g. '(XFeatureCall1 - XFeatureCall2)'
	        val featureCalls =  org::eclipse::xtend::typesystem::emf::EcoreUtil2::allContents(exp)
	        val xfeaturecalls = featureCalls.filter(typeof(XFeatureCall))
	        xfeaturecalls.exists[
	        	val feaID = feature.simpleName
	        	val fieID = field.simpleName
	        	val equal = feaID==fieID
	        	equal
	        ]
    	}
    
	]
    return result
  }
  
  /**
   * Get the Form container the given question is part of. 
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

