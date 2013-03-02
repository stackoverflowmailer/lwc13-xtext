package org.eclipse.xtext.example.qls.validation

import org.eclipse.xtext.example.qls.qlsDsl.Section
import org.eclipse.xtext.example.qls.qlsDsl.Page

class ValidationHelper {
	
	
	def dispatch getFirstParentDeclaringUsedForm(Section section) {
		if (section.form!=null)
		  return section
		  
		return getFirstParentDeclaringUsedForm(section.eContainer)
	}
	
	def dispatch getFirstParentDeclaringUsedForm(Page page) {
		if (page.form!=null)
		  return page
		
		return null
	}
	
	def dispatch parentDeclaresFormMessage(Section parent) {
		 return "Used form already declared by parent section "+parent.name
	}
	
	def dispatch parentDeclaresFormMessage(Page parent) {
		return "Used form already defined by parent page " + parent.name
	}
	
	def noUsedFormDeclaredMessage(Section section) {
      	return "No used form declared for section " + section.name
           + " or its parent sections/page";
  }
}