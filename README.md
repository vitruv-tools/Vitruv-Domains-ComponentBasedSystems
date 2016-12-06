# Vitruv-Domains

To run Maven successfully, you have to manually install a current version of JaMoPP in your local Maven repository. 

1. Download a current version of the "org.emftext.language.java" Plugin from http://update.jamopp.org/trunk/plugins/, e.g. http://update.jamopp.org/trunk/plugins/org.emftext.language.java_1.4.1.v201612061234.jar
2. Install the jar in your local repository via "mvn install:install-file -Dfile=PATH_TO_JAR -DgroupId=org.emftext -DartifactId=org.emftext.language.java -Dversion=1.4.1 -Dpackaging=jar"
