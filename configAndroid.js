// DO NOT CHANGE CODE AFTER THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING
const fs = require("fs");
const path = require("path");

// Configuration Constants
const configPath = path.join(
  __dirname,
  "cbConfig.json",
);
const configData = fs.readFileSync(configPath, "utf8");
const config = JSON.parse(configData);
// const PACKAGE_NAME = "com.cb.standard";
const PACKAGE_NAME = config.packageName || "com.cb.standard";

// 1. Check if the files exists
const googleServicesPath = path.join(
  __dirname,
  "android",
  "app",
  "google-services.json",
);
if (!fs.existsSync(googleServicesPath)) {
  console.error("\x1b[31mError: google-services.json not found at ./android/app/\x1b[0m");
  process.exit(1);
}

const firebaseOptionsPath = path.join(
  __dirname,
  "lib",
  "firebase_options.dart",
);
if (!fs.existsSync(firebaseOptionsPath)) {
  console.error("\x1b[31mError: firebase-options.dart not found at ./lib/\x1b[0m");
  process.exit(1);
}
const androidLocalPropertiesPath = path.join(
  __dirname,
  "android",
  "local.properties",
);
if (!fs.existsSync(androidLocalPropertiesPath)) {
  console.error("\x1b[31mError: android/local.properties does not exist.\x1b[0m");
  process.exit(1);
}

const pubSpecPath = path.join(__dirname, "pubspec.yaml");
if (!fs.existsSync(pubSpecPath)) {
  console.error("\x1b[31mError: pubspec.yaml does not exist.\x1b[0m");
  process.exit(1);
}
const wrapperPath = path.join(
  __dirname,
  "android",
  "gradle",
  "wrapper",
  "gradle-wrapper.properties",
);
if (!fs.existsSync(wrapperPath)) {
  console.error("\x1b[31mError: android/gradle/wrapper/gradle-wrapper.properties does not exist.\x1b[0m");
  process.exit(1);
}

const appGradlePath = path.join(
  __dirname,
  "android",
  "app",
  "build.gradle.kts",
);
if (!fs.existsSync(appGradlePath)) {
  console.error("\x1b[31mError: android/app/build.gradle.kts does not exist.\x1b[0m");
  process.exit(1);
}

// 2. Start Processing google-services.json
try {
  // 1. Read and parse the file
  const rawData = fs.readFileSync(googleServicesPath, "utf8");
  const googleServices = JSON.parse(rawData);

  // 2. Extracting data based on your mapping
  const projectInfo = googleServices.project_info;
  const client = googleServices.client.filter((c) => {
    return (
      c.client_info.android_client_info.package_name ===
      PACKAGE_NAME.toLocaleLowerCase()
    );
  });
  if (client.length !== 1) {
    console.error(
      `\x1b[31mError: No client found with package name ${PACKAGE_NAME.toLocaleLowerCase()}\x1b[0m`,
    );
    process.exit(1);
  }

  // 3. Map to FirebaseOptions structure
  const firebaseOptions = {
    apiKey: client[0].api_key[0].current_key,
    appId: client[0].client_info.mobilesdk_app_id,
    messagingSenderId: projectInfo.project_number,
    projectId: projectInfo.project_id,
    storageBucket: projectInfo.storage_bucket,
  };
  console.log(
    "\x1b[34mSuccessfully retrieved Firebase Options from google-services.json. \x1b[0m",
  );
  console.log(firebaseOptions);

  // 4. Write to a file like firebase-options.js

  let firebaseOptionsContent = fs.readFileSync(firebaseOptionsPath, "utf8");
  firebaseOptionsContent = firebaseOptionsContent.replace(
    /\tstatic const FirebaseOptions android = FirebaseOptions.*\{[\s\S]*?\}/,
    `\tstatic const FirebaseOptions android = FirebaseOptions(
      apiKey: "${firebaseOptions.apiKey}",
      appId: "${firebaseOptions.appId}",
      messagingSenderId: "${firebaseOptions.messagingSenderId}",
      projectId: "${firebaseOptions.projectId}",
      storageBucket: "${firebaseOptions.storageBucket}",
    );`,
  );
  fs.writeFileSync(firebaseOptionsPath, firebaseOptionsContent);
  console.log("\x1b[34mSuccessfully wrote Firebase Options to firebase-options.dart. \x1b[0m");
} catch (error) {
  console.error("\x1b[31mError parsing google-services.json. \x1b[0m", error.message);
  process.exit(1);
}

// 3. Update local.properties and pubspec.yaml
console.log("\x1b[34mUpdating local.properties and pubspec.yaml. \x1b[0m");
if (!fs.existsSync(androidLocalPropertiesPath)) {
  fs.appendFileSync(androidLocalPropertiesPath, `\nflutter.versionCode=1\n`);
}
if (fs.existsSync(pubSpecPath)) {
  let pubSpec = fs.readFileSync(pubSpecPath, "utf8");
  pubSpec = pubSpec.replace(/version: .*/, `version: 1.0.0`);
  fs.writeFileSync(pubSpecPath, pubSpec);
}

// 4. Update Gradle Wrapper (9.3.0)
if (fs.existsSync(wrapperPath)) {
  let wrapper = fs.readFileSync(wrapperPath, "utf8");
  wrapper = wrapper.replace(
    /distributionUrl=.*/,
    `distributionUrl=https\\://services.gradle.org/distributions/gradle-9.3.0-all.zip`,
  );
  fs.writeFileSync(wrapperPath, wrapper);
}

// 5. Update android/app/build.gradle with Java 17 and Desugaring

if (fs.existsSync(appGradlePath)) {
  let gradle = fs.readFileSync(appGradlePath, "utf8");

  // Replace compileOptions and kotlinOptions
  const newConfigs = `
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }
    `;

  // Regex to find and replace the old blocks
  gradle = gradle.replace(/compileOptions\s*{[\s\S]*?}/, newConfigs);
  gradle = gradle.replace(/kotlinOptions\s*{[\s\S]*?}/, ""); // Remove duplicate if exists

  // Ensure desugaring dependency is present
  if (!gradle.includes("coreLibraryDesugaring")) {
    gradle = gradle.replace(
      /dependencies\s*{/,
      `dependencies {\n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'`,
    );
  }

  fs.writeFileSync(appGradlePath, gradle);
}

console.log("\x1b[32mConfiguration Flutter Android Script Finished!\x1b[0m");
console.log("\x1b[34mNext steps: 1. Check that the Validation notes have been done. \x1b[0m");
console.log("\x1b[34mNext steps: 2. Copy the Firebase options to your firebase_options.dart file. \x1b[0m");
console.log("\x1b[34mNext steps: 3. Run 'node rebuild.js' to clean and run app. \x1b[0m");
console.log(
  "\x1b[34mYou are now ready to run your app with the new Firebase configuration and Android setup. \x1b[0m",
);

