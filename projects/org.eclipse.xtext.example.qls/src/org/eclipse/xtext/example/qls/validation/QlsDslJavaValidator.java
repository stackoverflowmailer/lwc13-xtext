package org.eclipse.xtext.example.qls.validation;

import java.util.Collection;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.example.qls.qlsDsl.Page;
import org.eclipse.xtext.example.qls.qlsDsl.QlsDslPackage;
import org.eclipse.xtext.example.qls.qlsDsl.Section;
import org.eclipse.xtext.validation.Check;

public class QlsDslJavaValidator extends AbstractQlsDslJavaValidator {

  protected ValidationHelper helper = new ValidationHelper();

  @Check
  public void checkUsedFormIsUnique(Section section) {

    EObject parentDeclaringUsedForm = helper
        .getFirstParentDeclaringUsedForm(section.eContainer());

    if (section.getForm() == null && parentDeclaringUsedForm == null) {
      error(helper.noUsedFormDeclaredMessage(section),
          QlsDslPackage.Literals.SECTION__NAME);
    } else if (section.getForm() != null && parentDeclaringUsedForm != null) {
      error(helper.parentDeclaresFormMessage(parentDeclaringUsedForm),
          QlsDslPackage.Literals.SECTION__FORM);
    }
  }

  @Check
  public void checkUsedFormIsRequired(Page page) {
    if (page.getForm() == null) {
      Collection<Object> allDirectQuestions = EcoreUtil2.getObjectsByType(
          page.getElement(), QlsDslPackage.eINSTANCE.getQuestion());

      if (!allDirectQuestions.isEmpty()) {
        error(
            "Page needs to declare the used form, since it contains questions not grouped by a section",
            QlsDslPackage.Literals.PAGE__NAME);
      }

    }
  }

}
