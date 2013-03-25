package org.eclipse.xtext.example.ql.validation

import javax.inject.Inject
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XbasePackage
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations

import static extension org.eclipse.xtext.nodemodel.util.NodeModelUtils.*

class QlDslXtendValidator extends AbstractQlDslJavaValidator {
  @Inject extension IJvmModelAssociations

  /**
   * Test for cyclic dependencies. For instance, the following snippet should
   * be rejected:
   * <pre>
   * if (x) { y: "Y?" boolean }
     if (y) { x: "X?" boolean }
   * </pre>
   *
   * The reason is that y will only be asked for when x is true,
   * but x will only get a value when y is true. Of course such cyclic
   * dependencies could occur transitively and nested in expressions. Another
   * way of stating this check is: the ordering of questions should be
   * consistent with how the question variables are used in conditions and
   * computed values.
   */
  @Check
  def void check_featureDeclaredBeforeCall (XFeatureCall featureCall) {
    val featureSource = featureCall.feature.sourceElements.head
    val nodeFeature = if (featureSource != null) featureSource.node else featureCall.feature.node
    val nodeCall = featureCall.node
    if (nodeFeature != null) {
      if (nodeFeature.offset > nodeCall.offset) {
        error(featureCall.feature.simpleName+" must be declared before.",featureCall,
          XbasePackage::eINSTANCE.XAbstractFeatureCall_Feature, "ERR_FEATURE_CALL_BEFORE_DECLARATION", null
        )
      }
    }
  }
}
