package org.eclipse.xtext.example.ql.customizing;

import java.util.Map;
import java.util.Set;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.common.types.JvmIdentifiableElement;
import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator;

/**
 * Workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=403678
 */
public class JvmModelAssociatorCustom extends JvmModelAssociator {
  @Override
  public JvmIdentifiableElement getLogicalContainer(EObject object) {
    if (object == null)
      return null;
    final Map<EObject, JvmIdentifiableElement> mapping = getLogicalContainerMapping(object
        .eResource());
    if (mapping.containsKey(object)) {
      return mapping.get(object);
    }
    if (object.eContainer() != null
        && !mapping.containsKey(object.eContainer())) {
      Set<EObject> elements = getJvmElements(object.eContainer());
      for (EObject eObject : elements) {
        if (eObject instanceof JvmIdentifiableElement && eObject != object) {
          return (JvmIdentifiableElement) eObject;
        }
      }
    }
    return null;
  }
}
