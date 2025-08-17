#!/bin/bash

# Android Video Recorder Build Script
# This script sets up the environment and builds the APK

set -e  # Exit on error

echo "=== Android Video Recorder Build Script ==="
echo "Setting up build environment..."

# Set Java environment
export JAVA_HOME=/home/charles-chang/finalrecking/prebuilts/jdk/jdk17/linux-x86
export PATH=$JAVA_HOME/bin:$PATH

echo "Using Java: $(java -version 2>&1 | head -1)"
echo "Android SDK: /home/charles-chang/Android/Sdk"

# Clean previous builds
echo "Cleaning previous builds..."
./gradlew clean

# Build debug APK
echo "Building debug APK..."
./gradlew assembleDebug

# Build release APK (optional)
echo "Building release APK..."
./gradlew assembleRelease

