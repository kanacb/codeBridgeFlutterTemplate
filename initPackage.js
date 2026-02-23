// DO NOT CHANGE CODE AFTER THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING
const fs = require("fs");
const { execSync } = require("child_process");
const path = require("path");
// Configuration Constants
const configPath = path.join(
  __dirname,
  "cbConfig.json",
);
const configData = fs.readFileSync(configPath, "utf8");
const config = JSON.parse(configData);
const PACKAGE_NAME = config.packageName || "com.cb.standard";

// Validate Configuration
if (PACKAGE_NAME === "com.cb.standard") {
  console.warn(
    "Warning: PACKAGE_NAME is set to 'com.cb.standard', which may not be unique. Consider changing it to avoid conflicts.",
  );
  process.exit(1);
}

// Firebase Config from your prompt
function run(command) {
  console.log(`\x1b[36mRunning: ${command}\x1b[0m`);
  try {
    execSync(command, { stdio: "inherit", message: `Executing: ${command}` });
  } catch (e) {
    console.error(`Error executing: ${command}`);
  }
}

// 1. Recreate Flutter Project
run(`flutter create .`);
run(`dart run change_app_package_name:main ${PACKAGE_NAME}`);

console.log("\x1b[32mRebuild Script Finished!\x1b[0m");
console.log("Next steps: 1. Create firebase Account and create a Android App, then download the google-services.json file and place it in the android/app/ directory.");
console.log("Next steps: 2. Run 'node configAndroid.js' to setup your android project.");


