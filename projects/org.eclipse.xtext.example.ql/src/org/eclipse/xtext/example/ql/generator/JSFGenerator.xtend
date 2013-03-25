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
import org.eclipse.xtext.example.ql.qlDsl.Form
import org.eclipse.xtext.xbase.XFeatureCall

class JSFGenerator implements IGenerator{
  @Inject extension IJvmModelAssociations
  @Inject extension JsfOutputConfigurationProvider
  // enumeration of class names which do not need a converter
  // see http://www.javabeat.net/2007/11/using-converters-in-jsf/
  override doGenerate(Resource input, IFileSystemAccess fsa) {
        if (input.URI.fileExtension!="ql")
            return

        //generate forms
        val questionnaire = input.contents.head as Questionnaire
        for (form: questionnaire.forms) {
        	//simple jsf which includes the generated form
            val content = generate_JSFPage(form)
            val fileName = "generated/forms/"+form.name+".xhtml"
            fsa.generateFile(fileName,WEB_CONTENT, content)
            
            //the base form which can be included in other pages
            val contentBase = generate_JSFBaseForm(form)
            val fileNameBase = "generated/forms/"+form.name+"Base.xhtml"
            fsa.generateFile(fileNameBase,WEB_CONTENT, contentBase)
        }

        //generate index page with links to generated forms
        val contentIndex  = generate_JSFIndexPage(questionnaire.forms)
        //TODO the generator is called once per resource, so the index page will be overwritten if there are more than model files
        fsa.generateFile("generated/forms/index.xhtml",WEB_CONTENT, contentIndex)

    }
    
    
  def generate_JSFBaseForm(Form form)'''
      <!-- @generated -->
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

    <html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:ui="http://java.sun.com/jsf/facelets"
      xmlns:h="http://java.sun.com/jsf/html"
      xmlns:f="http://java.sun.com/jsf/core">
  	 <h:form id="«form.id»">
      «FOR elem: form.element»
        «elem.generateFormElement»
      «ENDFOR»
          <!-- E N D _ generate_JSFPage _ S E C T I O N  -->
          </h:form>
    </html>
  '''
    
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
          <ui:include src="«form.name»Base.xhtml" />	
        </ui:define>
      </ui:composition>
    </html>
  '''

  //TODO in allen ConditionalQuestionGroup, wenn expression.parts.contains.question.name, dann return (ConditionalQuestionGroup.parts, seperator _,as String id for ajax rendering)
  //TODO ajax support, ids to render on change, sample: grp_state grp_ValueReside

	def generateFormElement(FormElement element)'''
	 <!-- generateFormElement(FormElement element) -->
	«IF element.isReferenced»
	<h:panelGroup id="«element.renderGroupId»">
		<h:panelGroup id="grp_«element.id»Visible"
			rendered="#{«element.formName».«element.id»Visible}">«ENDIF»
			 «element.generate»
	«IF element.isReferenced»
     	 </h:panelGroup>
     </h:panelGroup>«ENDIF»
	'''

  def dispatch generate (ConditionalQuestionGroup group) '''
        <!-- generate (ConditionalQuestionGroup group) -->
      «FOR elem: group.element»
        «elem.generateFormElement»
      «ENDFOR»
   '''
   

  //TODO a cleaner solution for providing extensibility of question types?
  //TODO special cases (readonly money, )
  def dispatch generate (Question question) '''
  <!-- generate (Question question) -->
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
      <f:ajax event="click" «question.ajaxRenderString»/>
    </h:selectBooleanCheckbox>
  '''

  def generateQuestionText(Question question) '''
    <h:inputText id="q_«question.id»" value="#{«question.formName+'.'+question.name»}"«IF question.expression!=null» readonly="true"«ENDIF»>
      <f:ajax event="blur" «question.ajaxRenderString»/>
      «generateConverter(question)»
    </h:inputText>
  '''
  
  def getAjaxRenderString (Question question) {
     //'''render="«question.renderGroupId» «FOR element : question.dependentElementsWithExpression SEPARATOR ' '»q_«element.id»«ENDFOR»"'''
     '''render="«FOR elem: question.dependentElementsWithExpression SEPARATOR ' '»«elem.getRenderGroupId»«ENDFOR»"'''
  }
   
  def generateConverter (Question question) {
    // primitive types and known classes do not require a special converter
    val needsConversion = !(question.type.type instanceof JvmPrimitiveType) 
       && !defaultConverters.contains(question.type.type.simpleName)
    if (needsConversion) {
      '''<f:converter converterId="converter.«question.type.type.simpleName»"/>'''
    } else
      ""
  }

  Set<String> defaultConverters = newHashSet ("BigDecimal","BigInteger",
    "Boolean","Byte","Character","DateTime","Double","Enum","Float","Integer","Long",
    "Number","Short","String"
  )


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
          <h:outputLink value="«elem.name».jsf">«elem.name»</h:outputLink>
        «ENDFOR»
        </ui:define>
      </ui:composition>
      </html>
  '''
  
  // --------------------------------------------------------------------------
  def String getId (EObject o) {
    switch (o) {
      ConditionalQuestionGroup: "group"+allConditionalGroups(o).indexOf(o)
      Question: o.name
      Form: o.name.toLowerCase
    }
  }

  def String getRenderGroupId (EObject elem) {
    switch (elem) {
      Form: "grp_"+elem.id
      ConditionalQuestionGroup: "grp_"+elem.id
     // FormElement: getRenderGroupId(elem.eContainer)//TODO 1.get panels that contain this exp 
      Question : "grp_"+elem.id
    }
  }


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
   org::eclipse::xtend::typesystem::emf::EcoreUtil2::allContents(form)
   
    val allResourceContents =  org::eclipse::xtend::typesystem::emf::EcoreUtil2::allContents(form)
    val Iterable<FormElement> allFormElementsWithExpression = allResourceContents
      .filter(typeof(FormElement))
      .filter[it.expression!=null]
      .toSet
      
   // search the expressions of the form elements which call the JvmField field in a feature call
   val result = allFormElementsWithExpression.filter[
    	
    	val exp = it.expression
    	if(exp instanceof XFeatureCall){
    		(exp as XFeatureCall) .feature.simpleName == field.simpleName	
    	}else{
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
	//TODO incorrect result gives any dependent elements
    return result
  }
  
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

