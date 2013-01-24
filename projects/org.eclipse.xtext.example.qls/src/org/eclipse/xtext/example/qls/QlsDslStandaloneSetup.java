
package org.eclipse.xtext.example.qls;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class QlsDslStandaloneSetup extends QlsDslStandaloneSetupGenerated{

	public static void doSetup() {
		new QlsDslStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

