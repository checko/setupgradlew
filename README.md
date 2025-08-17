# Hello Gradle - Android Project Setup Tool

A simple Android project with an automated Gradle setup script for easy environment configuration and building.

## Overview

This project demonstrates:
- Automated Gradle Wrapper download and configuration
- Environment setup for Android builds using existing JDK and Android SDK
- Simple "Hello World" Android application
- Portable setup script for use with other Android projects

## Project Structure

```
hellogradlew/
├── setupgradle.sh          # Main setup script
├── build.gradle           # Root build configuration
├── settings.gradle        # Project settings
├── gradle.properties      # Gradle properties
├── app/
│   ├── build.gradle       # App module build configuration
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/com/example/hellogradlew/
│       │   └── MainActivity.java
│       └── res/
│           ├── layout/activity_main.xml
│           └── values/strings.xml
└── build.sh              # Reference build script from working project
```

## Quick Start

1. **Run the setup script:**
   ```bash
   ./setupgradle.sh
   ```
   This will:
   - Download Gradle Wrapper if not present
   - Set up environment variables for Java and Android SDK
   - Create `gradle_env.sh` for easy environment setup

2. **Build the project:**
   ```bash
   source gradle_env.sh && ./gradlew build
   ```

3. **Build APK:**
   ```bash
   source gradle_env.sh && ./gradlew assembleDebug
   ```

## Environment Requirements

The setup script expects:
- **JDK 17**: `/home/charles-chang/finalrecking/prebuilts/jdk/jdk17/linux-x86`
- **Android SDK**: `/home/charles-chang/Android/Sdk`

These paths are configured based on your existing working Android build environment.

## Using with Existing Android Projects

The `setupgradle.sh` script is designed to be portable. To use it with other Android projects:

1. Copy `setupgradle.sh` to your Android project's root directory
2. Run `./setupgradle.sh`
3. Use `source gradle_env.sh && ./gradlew <task>` to build

## Available Gradle Tasks

Common tasks you can run after sourcing the environment:

```bash
# List all available tasks
source gradle_env.sh && ./gradlew tasks

# Build the project
source gradle_env.sh && ./gradlew build

# Build debug APK
source gradle_env.sh && ./gradlew assembleDebug

# Build release APK
source gradle_env.sh && ./gradlew assembleRelease

# Run tests
source gradle_env.sh && ./gradlew test

# Clean build files
source gradle_env.sh && ./gradlew clean
```

## Generated Files

After running `setupgradle.sh`, these files will be created:
- `gradlew` - Gradle wrapper script
- `gradlew.bat` - Gradle wrapper for Windows
- `gradle/wrapper/` - Gradle wrapper configuration
- `gradle_env.sh` - Environment variable setup script

These files are excluded from version control via `.gitignore`.

## Features

- **Automated Setup**: No manual Gradle installation required
- **Environment Isolation**: Uses specific JDK and Android SDK paths
- **Portable**: Works with any Android Gradle project
- **Version Controlled**: Only source code and configuration files are tracked

## Build Output

Successful builds will generate:
- Debug APK: `app/build/outputs/apk/debug/app-debug.apk`
- Release APK: `app/build/outputs/apk/release/app-release.apk`

## Troubleshooting

If you encounter build issues:

1. **Check Java and Android SDK paths** in `setupgradle.sh`
2. **Verify environment setup:**
   ```bash
   source gradle_env.sh
   echo $JAVA_HOME
   echo $ANDROID_HOME
   java -version
   ```
3. **Clean and rebuild:**
   ```bash
   source gradle_env.sh && ./gradlew clean build
   ```

## License

MIT License