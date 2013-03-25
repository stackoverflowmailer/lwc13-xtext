package org.eclipse.xtext.example.ql.validation;

import javax.inject.Inject;

import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations;

public class QlDslJavaValidator extends QlDslXtendValidator {
  @Inject
  IJvmModelAssociations a;
}
