package org.eclipse.xtext.example.ql.generator;

import java.util.Set;

import org.eclipse.xtext.generator.OutputConfiguration;
import org.eclipse.xtext.generator.OutputConfigurationProvider;

public class JSFOutputConfigurationProvider extends OutputConfigurationProvider {

  public final String WEB_CONTENT = "WebContent";

  /**
   * @return a set of {@link OutputConfiguration} available for the generator
   */
  public Set<OutputConfiguration> getOutputConfigurations() {
    Set<OutputConfiguration> outputConfigurations = super
        .getOutputConfigurations();

    OutputConfiguration webContent = new OutputConfiguration(WEB_CONTENT);
    webContent
        .setDescription("Read-only Output Folder for web generated application artifacts");
    webContent.setOutputDirectory("./WebContent");
    webContent.setOverrideExistingResources(true);
    webContent.setCreateOutputDirectory(true);
    webContent.setCleanUpDerivedResources(true);
    webContent.setSetDerivedProperty(true);
    outputConfigurations.add(webContent);

    return outputConfigurations;
  }
}