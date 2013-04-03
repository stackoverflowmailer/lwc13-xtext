package org.eclipse.xtext.example.qls.scoping

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.example.qls.QlsDslExtensions
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider

class QlsDslScopeProviderXtend extends AbstractDeclarativeScopeProvider {
	
  @Inject extension QlsDslExtensions
	
  def IScope scope_QuestionStyling_question(EObject context, EReference ref) {
    Scopes::scopeFor(
    	EcoreUtil2::getAllContentsOfType(context.form, typeof(Question))
    );
  }
}