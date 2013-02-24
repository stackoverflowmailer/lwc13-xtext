package org.eclipse.xtext.example.ql.generator

/* just conventions for names */
class JSFConvention {
	def static String prefixLabel(String name){'''lbl«name.toFirstUpper»'''}
	def static String prefixText(String name){'''txt«name.toFirstUpper»'''}
	def static String prefixCheck(String name){'''chk«name.toFirstUpper»'''}
	def static String prefixForm(String name){'''form«name.toFirstUpper»'''}
	def static String prefixDefine(String name){'''def«name.toFirstUpper»'''}
	def static String prefixPanelGroup(String name){'''pg«name.toFirstUpper»'''}	
}