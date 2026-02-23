// DO NOT CHANGE CODE AFTER THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING

const { execSync } = require('child_process');

function run(command, cwd = process.cwd()) {
  try {
    console.log(`\x1b[33m%s\x1b[0m`, `\nRunning: ${command}`);
    execSync(command, { stdio: 'inherit', cwd });
  } catch (error) {
    console.error(`\x1b[31m%s\x1b[0m`, `\nFailed to execute: ${command}`);
    process.exit(1);
  }
}

// 1. Clean Flutter
run('flutter clean');

// 2. Clean Android (handles both Windows and Unix-like systems)
const gradlewClean = process.platform === 'win32' ? 'gradlew.bat clean --warning-mode all' : './gradlew clean --warning-mode all';
run(gradlewClean, './android');

// 3. Get Packages
run('flutter pub get');

// 4. Build Hive Adapters
run('dart run build_runner build --delete-conflicting-outputs');

// 5. Run App
run('dart run');