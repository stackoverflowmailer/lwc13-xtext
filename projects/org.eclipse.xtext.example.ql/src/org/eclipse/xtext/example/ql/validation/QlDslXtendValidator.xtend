package org.eclipse.xtext.example.ql.validation

import javax.inject.Inject
import org.eclipse.xtext.example.ql.QlDslExtensions
import org.eclipse.xtext.example.ql.qlDsl.QlDslPackage
import org.eclipse.xtext.example.ql.qlDsl.Question
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.ValidationMessageAcceptor
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.nodemodel.util.NodeModelUtils

class QlDslXtendValidator extends AbstractQlDslJavaValidator {
	@Inject extension QlDslExtensions
	@Inject extension IJvmModelAssociations
	
	/**
	 * Test for cyclic dependencies. For instance, the following snippet should
	 * be rejected: 
	 * <pre>
	 * ￼￼if (x) { y: "Y?" boolean }
	   if (y) { x: "X?" boolean }
￼	 * </pre>
	 * 
	 * The reason is that y will only be asked for when x is true,
	 * but x will only get a value when y is true. Of course such cyclic
	 * dependencies could occur transitively and nested in expressions. Another
	 * way of stating this check is: the ordering of questions should be
	 * consistent with how the question variables are used in conditions and
	 * computed values.
	 */
	@Check
	def void checkCyclicDependencies (XFeatureCall featureCall) {
	  val question = featureCall.feature.sourceElements.head
	  if (question != null) {
	    val node = NodeModelUtils::getNode(question)
	    node.offset
	    if (node.offset > NodeModelUtils::getNode(featureCall).offset) {
	      error("Cyclic dependency for question "+featureCall.feature.qualifiedName+" in an expression.",question, QlDslPackage::eINSTANCE.question_Name, ValidationMessageAcceptor::INSIGNIFICANT_INDEX)
	    }
	  }
//		// these Questions have expressions that refer to 'question'
//		val dependentQuestions = question.getDependentElementsWithExpression.filter(typeof(Question))
//		
//		if (dependentQuestions.exists[
//			val dependentQuestionsForOther = it.getDependentElementsWithExpression.filter(typeof(Question))
//			val boolean isCyclic = dependentQuestionsForOther.toSet.contains(question)
//			return isCyclic
//		]) {
//			error("Cyclic dependency for question "+question.name+" in an expression.",question, QlDslPackage::eINSTANCE.question_Name, ValidationMessageAcceptor::INSIGNIFICANT_INDEX)
//		}
	}
	
}