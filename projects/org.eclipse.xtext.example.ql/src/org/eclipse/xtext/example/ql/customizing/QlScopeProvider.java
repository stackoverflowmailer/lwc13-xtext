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
 * @author thoms
 *
 */
@SuppressWarnings("restriction")
public class QlScopeProvider extends XbaseScopeProvider {
	@Inject
	private IJvmModelAssociations associations;

	@Override
	protected IScope createLocalVarScope(IScope parentScope,
			LocalVariableScopeContext scopeContext) {
		Form qlForm = EcoreUtil2.getContainerOfType(scopeContext.getContext(),
				Form.class);
		if (qlForm != null) {
			JvmType jvmTypeOfForm = getJvmType(qlForm);
			// bind the EClass' JvmType as variable 'this'
			IScope result = new SingletonScope(EObjectDescription.create(
					XbaseScopeProvider.THIS, jvmTypeOfForm),
					super.createLocalVarScope(parentScope, scopeContext));
			return result;

		}
		return super.createLocalVarScope(parentScope, scopeContext);
	}

	protected JvmType getJvmType(EObject context) {
		Iterable<JvmType> jvmTypes = Iterables.filter(
				associations.getJvmElements(context), JvmType.class);
		Iterator<JvmType> it = jvmTypes.iterator();
		JvmType result = it.hasNext() ? it.next() : null;
		return result;
	}

}
