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
  console.error("Error: google-services.json not found at ./android/app/");
  process.exit(1);
}

const firebaseOptionsPath = path.join(
  __dirname,
  "lib",
  "firebase_options.dart",
);
if (!fs.existsSync(firebaseOptionsPath)) {
  console.error("Error: firebase-options.dart not found at ./lib/");
  process.exit(1);
}
const androidLocalPropertiesPath = path.join(
  __dirname,
  "android",
  "local.properties",
);
if (!fs.existsSync(androidLocalPropertiesPath)) {
  console.warn("Warning: android/local.properties does not exist.");
  process.exit(1);
}

const pubSpecPath = path.join(__dirname, "pubspec.yaml");
if (!fs.existsSync(pubSpecPath)) {
  console.warn("Warning: pubspec.yaml does not exist.");
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
  console.warn(
    "Warning: android/gradle/wrapper/gradle-wrapper.properties does not exist.",
  );
  process.exit(1);
}

const appGradlePath = path.join(
  __dirname,
  "android",
  "app",
  "build.gradle.kts",
);
if (!fs.existsSync(appGradlePath)) {
  console.warn("Warning: android/app/build.gradle does not exist.");
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
      `Error: No client found with package name ${PACKAGE_NAME.toLocaleLowerCase()}`,
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
    "Successfully retrieved Firebase Options from google-services.json:",
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
  console.log("Successfully wrote Firebase Options to firebase-options.dart");
} catch (error) {
  console.error("Error parsing google-services.json:", error.message);
  process.exit(1);
}

// 3. Update local.properties and pubspec.yaml
console.log("Updating local.properties and pubspec.yaml...");
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

console.log("\x1b[32mRebuild Script Finished!\x1b[0m");
console.log(
  "You are now ready to run your app with the new Firebase configuration and Android setup.",
);
console.log("Next steps: 3. Run 'node rebuild.js' to clean and run app.");
