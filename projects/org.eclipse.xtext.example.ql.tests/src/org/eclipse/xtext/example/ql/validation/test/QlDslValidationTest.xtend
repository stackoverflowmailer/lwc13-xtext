package org.eclipse.xtext.example.ql.validation.test

import javax.inject.Inject
import org.eclipse.xtext.example.ql.QlDslInjectorProvider
import org.eclipse.xtext.example.ql.qlDsl.Questionnaire
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.XbasePackage
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(QlDslInjectorProvider))
class QlDslValidationTest {
  @Inject extension ParseHelper<Questionnaire> parseHelper
  @Inject extension ValidationTestHelper
  
  @Before
  def void setUp () {
    parseHelper.fileExtension="ql"
  }
  
  @Test
  def void testValidation_CallBeforeDeclaration_expectError () {
    '''
    form Foo {
      if (x) { y: "Y?" boolean }
      if (y) { x: "X?" boolean }
    }
    '''.parse.assertError(XbasePackage::eINSTANCE.XFeatureCall, "ERR_FEATURE_CALL_BEFORE_DECLARATION", "must be declared before")
  }

  @Test
  def void testValidation_CallBeforeDeclaration_expectSuccess () {
    '''
    form Foo {
      x: "foo" boolean
      if (x) { a: "X?" boolean }
    }
    '''.parse.assertNoErrors
  }
  
  
  // Type check conditions and variables: the expressions in conditions should be type correct and should ultimately be booleans. 
  // The assigned variables should be assigned consistently: each assignment should use the same type.  
  @Test
  def void testValidation_ConditionTypeCheck_expectError () {
    '''
    form Foo {
      if ("foo".length) { a: "X?" boolean }
    }
    '''.parse.assertError(XbasePackage::eINSTANCE.XMemberFeatureCall, 
       "org.eclipse.xtext.xbase.validation.IssueCodes.incompatible_types", "Type mismatch")
  }
  
  @Test
  def void testValidation_ConditionTypeCheck_expectSuccess () {
    '''
    form Foo {
      if ("foo".length>1) { a: "X?" boolean }
    }
    '''.parse.assertNoErrors
  }

  @Test
  def void testValidation_AssignmentTypeCheck_expectFailure () {
    '''
    form Foo {
      a: "X?" boolean ("foo".length)
    }
    '''.parse.assertError(XbasePackage::eINSTANCE.XMemberFeatureCall, 
       "org.eclipse.xtext.xbase.validation.IssueCodes.incompatible_types", "Type mismatch")
  }

  @Test
  def void testValidation_AssignmentTypeCheck_expectSuccess () {
    '''
    form Foo {
      a: "X?" boolean ("foo".length>1)
    }
    '''.parse.assertNoErrors
  }
}
