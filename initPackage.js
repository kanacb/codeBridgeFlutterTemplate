const { execSync } = require("child_process");

// Configuration Constants
const PACKAGE_NAME = "com.cb.standard";
const ORG_NAME = "com.cb.group";
const PLATFORMS = ["android", "ios", "windows", "web", "macos", "linux"];

// DO NOT CHANGE CODE AFTER THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING

// Validate Configuration
const allowedPlatforms = ["android", "ios", "windows", "web", "macos", "linux"];
if (!allowedPlatforms.every((p) => PLATFORMS.includes(p))) {
  console.error("Error: Invalid platform in PLATFORMS array", p);
  process.exit(1);
}
if (ORG_NAME === "com.cb.group") {
  console.warn(
    "Warning: ORG_NAME is set to 'com.cb.group', which may not be unique. Consider changing it to avoid conflicts.",
  );
  process.exit(1);
}
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
run(`flutter create --org ${ORG_NAME} --platforms=${PLATFORMS.join(",")} .`);
run(`dart run change_app_package_name:main ${PACKAGE_NAME}`);

console.log("\x1b[32mRebuild Script Finished!\x1b[0m");
console.log("Next steps: 1. Create firebase Account and create a Android App, then download the google-services.json file and place it in the android/app/ directory.");
console.log("Next steps: 2. Run 'node configAndroid.js' to setup your android project.");


