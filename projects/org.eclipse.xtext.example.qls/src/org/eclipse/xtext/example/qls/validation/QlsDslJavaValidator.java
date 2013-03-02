package org.eclipse.xtext.example.qls.validation;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.example.qls.qlsDsl.Page;
import org.eclipse.xtext.example.qls.qlsDsl.QlsDslPackage;
import org.eclipse.xtext.example.qls.qlsDsl.Section;
import org.eclipse.xtext.validation.Check;

public class QlsDslJavaValidator extends AbstractQlsDslJavaValidator {

  @Check
  public void checkUsedFormIsUnique(Section section) {
    if (section.getForm() == null) {
      if (getFirstParentDeclaringUsedForm(section) == null) {
        error(noUsedFormDeclaredMessage(section),
            QlsDslPackage.Literals.SECTION__NAME);
      }
    } else {
      EObject parentDeclaringUsedForm = getFirstParentDeclaringUsedForm(section);
      if (parentDeclaringUsedForm != null) {
        error(parentDeclaresFormMessage(parentDeclaringUsedForm),
            QlsDslPackage.Literals.SECTION__FORM);
      }
    }
  }

  private String noUsedFormDeclaredMessage(Section section) {
    return "No used form declared for section " + section.getName()
        + " or its parent sections";
  }

  private String parentDeclaresFormMessage(EObject context) {
    if (context instanceof Section)
      return "Used form already declared by section "
          + ((Section) context).getName();
    if (context instanceof Page)
      return "Used form already defined by page " + ((Page) context).getName();

    return "Unknown error";
  }

  private EObject getFirstParentDeclaringUsedForm(EObject section) {
    EObject parent = section.eContainer();
    if (parent instanceof Section) {
      Section parentSection = (Section) parent;
      if (parentSection.getForm() != null)
        return parentSection;
    } else if (parent instanceof Page) {
      Page parentPage = (Page) parent;
      if (parentPage.getForm() != null) {
        return parentPage;
      } else {
        // page is root parent
        return null;
      }
    }
    return getFirstParentDeclaringUsedForm(parent);
  }
}
