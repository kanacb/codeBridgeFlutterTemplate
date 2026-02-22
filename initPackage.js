const fs = require('fs');
const { execSync } = require('child_process');
const path = require('path');

const PACKAGE_NAME = 'com.cb.standard';
const ORG_NAME = 'com.cb';

// Firebase Config from your prompt
const firebaseOptions = `  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
  );`;

function run(command) {
    console.log(`\x1b[36mRunning: ${command}\x1b[0m`);
    try {
        execSync(command, { stdio: 'inherit' });
    } catch (e) {
        console.error(`Error executing: ${command}`);
    }
}

// 1. Recreate Flutter Project
run(`flutter create --org ${ORG_NAME} --platforms=android,ios,windows,macos,linux .`);
run(`dart run change_app_package_name:main ${PACKAGE_NAME}`);

// 2. Update local.properties and pubspec.yaml
console.log("Updating local.properties and pubspec.yaml...");
fs.appendFileSync('android/local.properties', `\npackageName=${PACKAGE_NAME}\n`);

// 3. Update Gradle Wrapper (9.3.0)
const wrapperPath = 'android/gradle/wrapper/gradle-wrapper.properties';
if (fs.existsSync(wrapperPath)) {
    let wrapper = fs.readFileSync(wrapperPath, 'utf8');
    wrapper = wrapper.replace(/distributionUrl=.*/, `distributionUrl=https\\://services.gradle.org/distributions/gradle-9.3.0-all.zip`);
    fs.writeFileSync(wrapperPath, wrapper);
}

// 4. Update android/app/build.gradle with Java 17 and Desugaring
const appGradlePath = 'android/app/build.gradle';
if (fs.existsSync(appGradlePath)) {
    let gradle = fs.readFileSync(appGradlePath, 'utf8');

    // Replace compileOptions and kotlinOptions
    const newConfigs = `
    compileOptions {
        coreLibraryDesugaringEnabled = true
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }
    `;

    // Regex to find and replace the old blocks
    gradle = gradle.replace(/compileOptions\s*{[\s\S]*?}/, newConfigs);
    gradle = gradle.replace(/kotlinOptions\s*{[\s\S]*?}/, ""); // Remove duplicate if exists
    
    // Ensure desugaring dependency is present
    if (!gradle.includes('coreLibraryDesugaring')) {
        gradle = gradle.replace(/dependencies\s*{/, `dependencies {\n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'`);
    }

    fs.writeFileSync(appGradlePath, gradle);
}

// 5. Update Firebase Options (Mock update)
const firebasePath = 'lib/firebase_options.dart';
if (fs.existsSync(firebasePath)) {
    let fbFile = fs.readFileSync(firebasePath, 'utf8');
    fbFile = fbFile.replace(/static const FirebaseOptions android = FirebaseOptions\([\s\S]*?\);/, firebaseOptions);
    fs.writeFileSync(firebasePath, fbFile);
    console.log("Updated firebase_options.dart");
} else {
    console.log("Note: lib/firebase_options.dart not found. Skipping file update.");
}

console.log("\x1b[32mRebuild Script Finished!\x1b[0m");
console.log("Next steps: 1. Place google-services.json in android/app/ 2. Run 'flutter run'");