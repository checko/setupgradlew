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
├── fix-android-project.sh  # Android project diagnostic and fix tool
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

The scripts are designed to be portable. To use them with other Android projects:

1. **Copy scripts** to your Android project's root directory:
   ```bash
   cp setupgradle.sh /path/to/your/project/
   cp fix-android-project.sh /path/to/your/project/
   ```

2. **Fix project structure** (if needed):
   ```bash
   ./fix-android-project.sh
   ```

3. **Setup Gradle environment**:
   ```bash
   ./setupgradle.sh
   ```

4. **Build the project**:
   ```bash
   source gradle_env.sh && ./gradlew <task>
   ```

### Android Project Fix Tool

The `fix-android-project.sh` script automatically diagnoses and fixes common Android project issues:

- **Missing root `build.gradle`** - Creates with proper Android plugin configuration
- **Missing `settings.gradle`** - Creates with plugin management and repositories
- **Missing `gradle.properties`** - Creates with Android project defaults
- **Plugin compatibility issues** - Validates app/build.gradle plugin syntax
- **Environment validation** - Checks for gradle_env.sh and gradlew

**Common use case:** Fix the error "Plugin [id: 'com.android.application'] was not found"

```bash
cd /path/to/broken/android/project
./fix-android-project.sh    # Fixes missing configuration files
./setupgradle.sh           # Sets up Gradle wrapper and environment
source gradle_env.sh && ./gradlew tasks  # Test the setup
```

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

1. **Run the fix script first:**
   ```bash
   ./fix-android-project.sh
   ```

2. **Check Java and Android SDK paths** in `setupgradle.sh`

3. **Verify environment setup:**
   ```bash
   source gradle_env.sh
   echo $JAVA_HOME
   echo $ANDROID_HOME
   java -version
   ```

4. **Clean and rebuild:**
   ```bash
   source gradle_env.sh && ./gradlew clean build
   ```

### Common Issues and Solutions

- **"Plugin [id: 'com.android.application'] was not found"**
  → Run `./fix-android-project.sh` to create missing root configuration files

- **"gradlew: command not found"**
  → Run `./setupgradle.sh` to download Gradle wrapper

- **"JAVA_HOME is not set"**
  → Run `source gradle_env.sh` before using gradlew

- **Build fails with dependency resolution errors**
  → Check that `google()` and `mavenCentral()` repositories are configured in build.gradle

## License

MIT License