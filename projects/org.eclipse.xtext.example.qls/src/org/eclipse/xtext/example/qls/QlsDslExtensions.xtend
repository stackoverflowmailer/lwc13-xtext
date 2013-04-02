package org.eclipse.xtext.example.qls

import org.eclipse.xtext.example.ql.qlDsl.Form
import org.eclipse.xtext.example.qls.qlsDsl.Section
import org.eclipse.xtext.example.qls.qlsDsl.Page

class QlsDslExtensions {
	
  def dispatch Form getForm(Section section) {
	if (section.form != null) {
	  section.form
	}
	else {
	  section.eContainer.form
	}
  }
	
  def dispatch getForm(Page page) {
	page.form
  }
}