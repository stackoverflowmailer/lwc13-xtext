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
import org.eclipse.xtext.common.types.JvmPrimitiveType
import java.util.Set

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
            val content = generate_JSFPage(form)
            val fileName = "generated/forms/"+form.name+".xhtml"
            fsa.generateFile(fileName,WEB_CONTENT, content)
        }

        //generate index page with links to generated forms
        val contentIndex  = generate_JSFIndexPage(questionnaire.forms)
        fsa.generateFile("generated/forms/index.xhtml",WEB_CONTENT, contentIndex)

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
           <!-- B E G I N _ M A I N _ S E C T I O N  -->
            <h:panelGroup id="grp_«form.name.toFirstLower»Form">
              <!-- evaluation part, every expression has one -->
              <h:panelGroup id="«form.renderGroupId»">
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

  def dispatch generate (ConditionalQuestionGroup group) '''
    <h:panelGroup id="«group.renderGroupId»">
      <h:panelGroup id="group_«group.id»Visible"
        rendered="#{«group.formName».«group.id»Visible}">
      «FOR elem: group.element»
        «elem.generate»
      «ENDFOR»
      </h:panelGroup>
    </h:panelGroup>
   '''
   

  //TODO a cleaner solution for providing extensibility of question types?
  //TODO special cases (readonly money, )
  def dispatch generate (Question question) '''
    <h:outputLabel value="«question.label»"/>

    «switch(question.type.type){
        JvmPrimitiveType: {
          switch (question.type.simpleName.toLowerCase){
            case "boolean": '''«generateQuestionBoolean(question)»'''
          }
        }
        default : '''«generateQuestionText(question)»'''
      }»
     <br/>
  '''

  def generateQuestionBoolean(Question question) '''
    <h:selectBooleanCheckbox id="q_«question.id»" value="#{«question.formName+'.'+question.name»}">
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
      '''render="«question.renderGroupId» «FOR element : question.dependentElementsWithExpression SEPARATOR ' '»q_«element.id»«ENDFOR»"'''
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
      Question: o.name.toLowerCase
      Form: o.name.toLowerCase
    }
  }

  def String getRenderGroupId (EObject elem) {
    switch (elem) {
      Form: "grp_"+elem.id
      ConditionalQuestionGroup: "grp_"+elem.id
      FormElement: getRenderGroupId(elem.eContainer)
    }
  }


  def private allConditionalGroups (EObject ctx) {
    ctx.eResource.allContents.filter(typeof(ConditionalQuestionGroup)).toList
  }

  def getFormName(FormElement elem){ 
    EcoreUtil2::getContainerOfType(elem, typeof(Form)).name.toFirstLower
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
    val Iterable<FormElement> allFormElementsWithExpression = field.eResource.allContents
      .filter(typeof(FormElement))
      .filter[it.expression!=null]
      .toList
    // search the expressions of the form elements which call the JvmField field in a feature call
    val result = allFormElementsWithExpression.filter[
        val featureCalls = it.expression.eAllContents.filter(typeof(XFeatureCall))
        featureCalls.exists[feature==field]
    ].toSet
    return result
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

