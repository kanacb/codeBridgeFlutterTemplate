# Code Bridge Flutter App

## Run the following commands

### Steps to get started

flutter create --org com.cb.standard --platforms=android,ios,windows,macos,linux .
dart run change_app_package_name:main com.cb.standard

Register with Firebase and Create Android App
Download the google-services.json into android/app folder
update /lib/firebase-options.dart with values from
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
  );

check if this gradle version is correct
distributionUrl=https\://services.gradle.org/distributions/gradle-9.3.0-all.zip

check if the below is correct
Place the package name in local.properties and pubspec.yaml file

Update android/app/build.gradle
====== start ======
compileOptions {
        isCoreLibraryDesugaringEnabled  = true 
        // Change 1.8 to VERSION_17
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

kotlinOptions {
        // Change '1.8' to '17'
        jvmTarget = '17'
    }

====== end ======

#change to java17
In VS Code / Android Studio: Go to Settings > Build, Execution, Deployment > Build Tools > Gradle. Change the Gradle JDK to JDK 17.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



