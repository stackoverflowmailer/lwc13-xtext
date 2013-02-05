package org.eclipse.xtext.example.ql.generator

import org.eclipse.xtext.generator.IGenerator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.example.ql.qlDsl.Form
import org.eclipse.xtext.example.ql.qlDsl.Questionnare

class JSFGenerator implements IGenerator{
	

	override doGenerate(Resource input, IFileSystemAccess fsa) {
		if (input.URI.fileExtension!="ql")
			return
		
		val questionnaire = input.contents.head as Questionnare
		for (form: questionnaire.forms) {
			val content = generate_JSFPage(form)
			val fileName = "WebContent/"+form.name+".xhtml"
			fsa.generateFile(fileName, content)
		}
	}
	
	def generate_JSFPage (Form form) '''
		<html>
		
		</html>
	'''
}
