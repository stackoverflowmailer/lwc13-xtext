package org.eclipse.xtext.example.ql.validation.test

import javax.inject.Inject
import org.eclipse.xtext.example.ql.QlDslInjectorProvider
import org.eclipse.xtext.example.ql.qlDsl.Questionnaire
import org.eclipse.xtext.example.ql.validation.IssueCodes
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
    '''.parse.assertError(XbasePackage::eINSTANCE.XFeatureCall, IssueCodes::FEATURE_CALL_BEFORE_DECLARATION, "must be declared before")
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
}