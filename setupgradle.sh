#!/bin/bash

# Gradle Setup Script
# This script downloads and installs necessary packages and environment
# for Android Gradle projects to build successfully

set -e  # Exit on error

echo "=== Gradle Project Setup Script ==="
echo "Setting up environment for Android Gradle builds..."

# Set Java environment (using the same paths from working build.sh)
export JAVA_HOME=/home/charles-chang/finalrecking/prebuilts/jdk/jdk17/linux-x86
export PATH=$JAVA_HOME/bin:$PATH

# Set Android SDK environment
export ANDROID_HOME=/home/charles-chang/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

echo "Java Home: $JAVA_HOME"
echo "Android SDK: $ANDROID_HOME"

# Check if Java is available
if [ ! -d "$JAVA_HOME" ]; then
    echo "Error: Java JDK not found at $JAVA_HOME"
    echo "Please ensure JDK 17 is installed at the specified location"
    exit 1
fi

# Check if Android SDK is available
if [ ! -d "$ANDROID_HOME" ]; then
    echo "Error: Android SDK not found at $ANDROID_HOME"
    echo "Please install Android SDK at the specified location"
    exit 1
fi

echo "Using Java: $(java -version 2>&1 | head -1)"

# Create gradle wrapper directory if needed
mkdir -p gradle/wrapper

# Download Gradle Wrapper if not present
if [ ! -f "gradlew" ]; then
    echo "Downloading Gradle Wrapper..."
    
    # Create gradle wrapper properties
    cat > gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF
    
    # Download gradle wrapper jar
    curl -L -o gradle/wrapper/gradle-wrapper.jar https://raw.githubusercontent.com/gradle/gradle/v8.7.0/gradle/wrapper/gradle-wrapper.jar
    
    # Create gradlew script
    curl -L -o gradlew https://raw.githubusercontent.com/gradle/gradle/v8.7.0/gradlew
    curl -L -o gradlew.bat https://raw.githubusercontent.com/gradle/gradle/v8.7.0/gradlew.bat
    
    chmod +x gradlew
    echo "Gradle Wrapper downloaded and configured"
else
    echo "Gradle Wrapper already exists"
fi

# Create a basic .bashrc addition for environment variables
cat > gradle_env.sh << 'EOF'
# Gradle environment variables
export JAVA_HOME=/home/charles-chang/finalrecking/prebuilts/jdk/jdk17/linux-x86
export PATH=$JAVA_HOME/bin:$PATH
export ANDROID_HOME=/home/charles-chang/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH
EOF

echo "=== Setup Complete ==="
echo "Environment is ready for Gradle builds"
echo ""
echo "Java: $(java -version 2>&1 | head -1)"
echo "Gradle Wrapper: Available"
echo "Android SDK: $ANDROID_HOME"
echo ""
echo "To use Gradle, source the environment first:"
echo "  source gradle_env.sh && ./gradlew tasks"
echo "  source gradle_env.sh && ./gradlew build"
echo "  source gradle_env.sh && ./gradlew assembleDebug"