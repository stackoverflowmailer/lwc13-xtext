The [Language Workbench Challenge](http://www.languageworkbenches.net/) is an initiative created by a group of experts at the [CodeGeneration 2010](http://www.codegeneration.net/cg2010/) conference. The aim is to set a common task for Language Workbenches which is implemented with the different existing alternatives in a comparable way.

This project realizes the [2013 Challenge](http://www.languageworkbenches.net/images/5/53/Ql.pdf) with Xtext, which is one of the most well known Language Workbenches. The challenge is to create a DSL for questionnaiers and generate a simple GUI for it.

http://kthoms.files.wordpress.com/2013/04/screenshot-2013-04-08-um-13-52-06.png?w=1536&h=707

Version 1.0 of the document is available for download: [LWC13-XtextSubmission.pdf](http://lwc13-xtext.eclipselabs.org.codespot.com/files/LWC13-XtextSubmission.pdf).

Draft versions can be downloaded here: [LWC13-XtextSubmission.pdf (DRAFT)](http://lwc13-xtext.eclipselabs.org.codespot.com/git/docs/lwc13-doc/LWC13-XtextSubmission.pdf).

The developed plugins are available for install through this [Eclipse Update Site](https://kthoms.ci.cloudbees.com/job/lwc13-dsl/lastSuccessfulBuild/artifact/projects/org.eclipse.xtext.example.ql.repository/target/repository/).

Quick Start:
  1. Download [Eclipse IDE for Java EE Developers](http://www.eclipse.org/downloads/packages/eclipse-ide-java-ee-developers/junosr2) for your OS
  1. Start Eclipse with a fresh workspace
  1. Download [bookmarks-dsl.xml](http://lwc13-xtext.eclipselabs.org.codespot.com/git/devenv/lwc13.devenv/bookmarks-dsl.xml)
  1. Open Eclipse Preferences, go to _Install/Update / Available Software Sites_
  1. Press _Import_ and select _bookmarks-dsl.xml_, close preferences
  1. Open _Help / Install New Software_
  1. Select _Work With: QL DSL Repository_
  1. Select _DSL / QlDsl SDK Feature_
  1. Finish the dialog to install the DSL feature
  1. Download [JSF-QL-1.1.zip](http://lwc13-xtext.eclipselabs.org.codespot.com/files/JSF-QL-1.1.zip)
  1. Import the project with _File / Import / General / Existing Projects into Workspace_. Check the _"Select archive file"_ option and select the downloaded zip file.
  1. Select the project and right-click on it. Select _Run As / Run on Server_
  1. Edit _Java Resources / src / model / questionnaires.ql_ to work with the QL DSL editor. Source code is immediately regenerated. Some changes might require restart of the server.