const { execSync } = require('child_process');

/**
 * Runs a shell command and logs output to the console.
 * Stops execution if a command fails.
 */
function runCommand(command, cwd = process.cwd()) {
  try {
    console.log(`\x1b[33m%s\x1b[0m`, `\nRunning: ${command}`);
    execSync(command, { stdio: 'inherit', cwd });
  } catch (error) {
    console.error(`\x1b[31m%s\x1b[0m`, `\nFailed to execute: ${command}`);
    process.exit(1);
  }
}

// 1. Clean Flutter
runCommand('flutter clean');

// 2. Clean Android (handles both Windows and Unix-like systems)
const gradlewClean = process.platform === 'win32' ? 'gradlew.bat clean' : './gradlew clean';
runCommand(gradlewClean, './android');

// 3. Get Packages
runCommand('flutter pub get');

// 5. Build Hive Adapters
runCommand('flutter pub run build_runner build --delete-conflicting-outputs');

// 5. Run App
runCommand('flutter run');