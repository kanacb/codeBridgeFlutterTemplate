# Code Bridge Flutter App

## Run the following commands to get started

1. In VS Code / Android Studio: Go to Settings > Build, Execution, Deployment > Build Tools > Gradle. Change the Gradle JDK to JDK 17. Download the latest version from Oracle Java.

2. Set the package name in /cbConfig.json

3. run 'node initPackage.js' // follow the instructions

4. Create Firebase Project, with billing enabled. Set the package name to the one set in the cbConfig file.

5. run 'node configAndroid.js' // follow the instructions

6. run 'node rebuild.js' // clean and rebuild your app

Additional Android Validation Notes:
### set the gradle version in android/gradle/wrapper/gradle-wrapper.properties 
distributionUrl=https\://services.gradle.org/distributions/gradle-9.3.0-all.zip

### rebuild adapters
dart run build_runner build --delete-conflicting-outputs

### set the values like below in the android/app/build.gradle.kts file
====== start ======
    defaultConfig {
        multiDexEnabled = true
    }

    compileOptions {
        // Change 11 to VERSION_17
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled  = true 
    }

    kotlinOptions {
        // Change '11' to '17'
        jvmTarget = '17'
    }

    dependencies {
        coreLibraryDesugaring ("com.android.tools:desugar_jdk_libs:2.0.3")
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

