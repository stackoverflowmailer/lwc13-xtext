
package org.eclipse.xtext.example.ql;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class QlDslStandaloneSetup extends QlDslStandaloneSetupGenerated{

	public static void doSetup() {
		new QlDslStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

