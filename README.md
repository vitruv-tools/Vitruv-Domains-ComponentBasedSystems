# Vitruv-Domains

[![Travis CI](https://img.shields.io/travis/vitruv-tools/Vitruv-Domains.svg)](https://travis-ci.org/vitruv-tools/Vitruv-Domains)
[![Issues](https://img.shields.io/github/issues/vitruv-tools/Vitruv-Domains.svg)](https://github.com/vitruv-tools/Vitruv-Domains/issues)
[![License](https://img.shields.io/github/license/vitruv-tools/Vitruv-Domains.svg)](https://raw.githubusercontent.com/vitruv-tools/Vitruv-Domains/master/LICENSE)

The Vitruv domains repository contains domain extensions to be used by applications for the [Vitruv framework](https://github.com/vitruv-tools/Vitruv/).

## Running Maven

To run Maven successfully, you have to manually install a current version of JaMoPP in your local Maven repository.

1. Download a current version of the "org.emftext.language.java" Plugin from http://update.jamopp.org/trunk/plugins/, e.g. http://update.jamopp.org/trunk/plugins/org.emftext.language.java_1.4.1.v201612061234.jar
2. Install the jar in your local repository via "mvn install:install-file -Dfile=PATH_TO_JAR -DgroupId=org.emftext -DartifactId=org.emftext.language.java -Dversion=1.4.1 -Dpackaging=jar"
