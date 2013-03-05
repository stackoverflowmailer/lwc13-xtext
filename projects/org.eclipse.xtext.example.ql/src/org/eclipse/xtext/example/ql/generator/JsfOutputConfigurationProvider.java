package org.eclipse.xtext.example.ql.generator;

import java.util.Set;

import org.eclipse.xtext.generator.OutputConfiguration;
import org.eclipse.xtext.generator.OutputConfigurationProvider;

public class JsfOutputConfigurationProvider extends OutputConfigurationProvider {

  public final String WEB_CONTENT = "WebContent";
  public final String WEB_INF = "WebInf";

  /**
   * @return a set of {@link OutputConfiguration} available for the generator
   */
  public Set<OutputConfiguration> getOutputConfigurations() {
    Set<OutputConfiguration> outputConfigurations = super
        .getOutputConfigurations();

    OutputConfiguration webContent = new OutputConfiguration(WEB_CONTENT);
    webContent.setDescription("Read-only Output Folder for forms");
    webContent.setOutputDirectory("./WebContent/gen/");
    webContent.setOverrideExistingResources(true);
    webContent.setCreateOutputDirectory(true);
    webContent.setCleanUpDerivedResources(true);
    webContent.setSetDerivedProperty(true);
    outputConfigurations.add(webContent);

    OutputConfiguration webInf = new OutputConfiguration(WEB_INF);
    webInf.setDescription("Read-only Output Folder for configurations");
    webInf.setOutputDirectory("./WebContent/WEB-INF/gen/");
    webInf.setOverrideExistingResources(true);
    webInf.setCreateOutputDirectory(true);
    webInf.setCleanUpDerivedResources(true);
    webInf.setSetDerivedProperty(true);
    outputConfigurations.add(webInf);

    return outputConfigurations;
  }
}