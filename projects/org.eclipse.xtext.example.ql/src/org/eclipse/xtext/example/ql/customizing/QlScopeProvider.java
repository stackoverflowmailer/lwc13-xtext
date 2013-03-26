package org.eclipse.xtext.example.ql.customizing;

import java.util.Iterator;

import javax.inject.Inject;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.common.types.JvmType;
import org.eclipse.xtext.example.ql.qlDsl.Form;
import org.eclipse.xtext.resource.EObjectDescription;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.scoping.impl.SingletonScope;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations;
import org.eclipse.xtext.xbase.scoping.LocalVariableScopeContext;
import org.eclipse.xtext.xbase.scoping.XbaseScopeProvider;

import com.google.common.collect.Iterables;

/**
 * Adds local variable bindings for expressions.
 */
@SuppressWarnings("deprecation")
public class QlScopeProvider extends XbaseScopeProvider {
  @Inject
  private IJvmModelAssociations associations;

  @Override
  protected IScope createLocalVarScope(IScope parentScope,
      LocalVariableScopeContext scopeContext) {
    // search the Form instance of the current context by traversing
    // the containment hierarchy
    Form qlForm = EcoreUtil2.getContainerOfType(scopeContext.getContext(),
        Form.class);
    if (qlForm != null) {
      // form found => get the JvmType representative of the Form
      JvmType jvmTypeOfForm = getJvmType(qlForm);
      // bind the EClass' JvmType as variable 'this' by creating
      // a scope that consists of only one element, and delegate
      // to the default implementation as outer scope
      IScope result = new SingletonScope(EObjectDescription.create(
          XbaseScopeProvider.THIS, jvmTypeOfForm), super.createLocalVarScope(
          parentScope, scopeContext));
      return result;

    }
    return super.createLocalVarScope(parentScope, scopeContext);
  }

  /**
   * Find the JvmType associated with an object
   * 
   * @param context
   *          Some model object
   * @return The JvmType associated with the object, usually derived by the
   *         IJvmModelInferrer. Returns <code>null</code> if the object is not
   *         associated to an JvmType.
   */
  private final JvmType getJvmType(EObject context) {
    Iterable<JvmType> jvmTypes = Iterables.filter(
        associations.getJvmElements(context), JvmType.class);
    Iterator<JvmType> it = jvmTypes.iterator();
    JvmType result = it.hasNext() ? it.next() : null;
    return result;
  }

}
