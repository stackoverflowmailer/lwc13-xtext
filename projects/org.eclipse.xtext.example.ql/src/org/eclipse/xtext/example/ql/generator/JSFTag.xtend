package org.eclipse.xtext.example.ql.generator

/* provides a set of reusable jsf-tags */

//TODO should use JSFConventions for ids
//TODO tag-prefix should be set here also (e.g. the f of f:ajax || the ui of ui:composition @see opHtml())
//TODO could be a good idea to seperate provided tags in different classes

class JSFTag {
	
	/**
	 * returns a minimal ajax tag which can be embedded in control elements such as InputText or CheckBox
	 * @param event = event which triggers ajax request (e.g. 'click' OR 'change')
	 * @param execute = the control elements which should be processed on server side (default is @this)
	 * @param render = a space separated list of elementIds which should be re-rendered after request
	 */
	def getAjaxSupport(String event,String execute,String render) 
	'''<f:ajax«
		IF event != null» event="«event»"«ENDIF»«
		IF execute != null» execute="«execute»"«ENDIF»«
		IF render != null» render="«render»"«ENDIF»/>'''
	 
	def clDefine() {
		'''</ui:define>'''
	}

	def opDefine(String id) {
		'''<ui:define name="«id»">'''
	}

	def clComposition() {
	'''</ui:composition>'''}

	def opComposition(String template) {
	'''<ui:composition '''+
		if(template != null) {
			'''template="«template»"'''
		}
		+'''>'''
		}
	
	/**
	 * open an inputText element
	 * @param id the id of the element
	 * @param valueExpression the expression evaluated for the inputText value (e.g. direct value OR BeanBinding)
	 * @param closed if true, the tag will be directly closed. calling clInputText is not necessary.
	 */
	def opInputText(String id, String valueExpression,boolean closed) {
	'''<h:inputText id="«JSFConvention::prefixText(id)»"
		value="#{«valueExpression»}"'''+if(closed){'''/>'''}else{'''>'''}}
		
	def clInputText(){'''</h:inputText>'''}
	
	def opOutputLabel(String id, String labelText,boolean closed) {
	'''<h:outputLabel id="«id»" value="«labelText»" '''+if(closed){'''/>'''}else{'''>'''}}	
	
	def clOutputLabel() {
	'''<h:outputLabel/>'''}	
	
	def opForm(String name) {'''<h:form id="«JSFConvention::prefixForm(name)»">'''}
	def clForm() {'''</h:form>'''}
	
	def opPanelGroup(String name) {'''<h:form id="«JSFConvention::prefixForm(name)»">'''}
	def clPanelGroup() {'''</h:panelGroup>'''}
	
	
	def docType() {'''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''' }
	
	def opHtml(boolean jsfFacelets, boolean jsfHtml, boolean jsfCore) {
		'''<html xmlns="http://www.w3.org/1999/xhtml"'''
		+if(jsfFacelets){
		''' xmlns:ui="http://java.sun.com/jsf/facelets"'''}
		+if(jsfHtml){
		''' xmlns:h="http://java.sun.com/jsf/html"
		'''}
		+if(jsfCore){
		''' xmlns:f="http://java.sun.com/jsf/core"'''}
		+'''>'''
	}
	def clHtml() {'''</html>'''}
	}