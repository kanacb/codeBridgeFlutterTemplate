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
    "\x1b[33mWarning: PACKAGE_NAME is set to 'com.cb.standard', which may not be unique. Consider changing it to avoid conflicts.\x1b[0m",
  );
  process.exit(1);
}

// Firebase Config from your prompt
function run(command) {
  console.log(`\x1b[36mRunning: ${command}\x1b[0m`);
  try {
    execSync(command, { stdio: "inherit", message: `Executing: ${command}` });
  } catch (e) {
    console.error(`\x1b[31mError executing: ${command}\x1b[0m`);
  }
}

// 1. Recreate Flutter Project
run(`flutter create .`);
run(`dart run change_app_package_name:main ${PACKAGE_NAME}`);

console.log("\x1b[32mInitialization Flutter Application Script Finished!. \x1b[0m");
console.log("\x1b[34mNext steps: 1. Create a new Firebase Project with billing enabled. \x1b[0m");
console.log("\x1b[34mNext steps: 2. Create a Android App in Project Settings -> General -> Your Apps -> Add App -> Android and follow the instructions to generate the google-services.json file. \x1b[0m");
console.log("\x1b[34mNext steps: 3. Download the google-services.json file. \x1b[0m");
console.log("\x1b[34mNext steps: 4. Place it in the /android/app/ directory. \x1b[0m");
console.log("\x1b[34mNext steps: 5. Run 'node configAndroid.js' and continue to follow the setup instructions. \x1b[0m");


