# Code Bridge Flutter App

## Run the following commands to get started

### change to java 17
1. In VS Code / Android Studio: Go to Settings > Build, Execution, Deployment > Build Tools > Gradle. Change the Gradle JDK to JDK 17. Download the latest version from Oracle Java.

2. run node initPackage.js // ensure the script configured to your system

3. run node configAndroid.js // set the build environment for android

4. run node rebuild.js // clean and rebuild your app

Validation Notes:
### check if this gradle version is correct
distributionUrl=https\://services.gradle.org/distributions/gradle-9.3.0-all.zip

### check if the below files have the correct version number
Place the package name in local.properties and pubspec.yaml file

### check if the version is set to 17 inenjoy android/app/build.gradle
====== start ======
compileOptions {
        // Change 1.8 to VERSION_17
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled  = true 
    }

kotlinOptions {
        // Change '1.8' to '17'
        jvmTarget = '17'
    }

====== end ======

enjoy coding.

## Getting Started with Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



