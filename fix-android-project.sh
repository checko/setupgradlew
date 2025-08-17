#!/bin/bash

# Android Project Fix Script
# This script checks and fixes common Android Gradle project issues

set -e

echo "=== Android Project Diagnostic and Fix Script ==="
echo "Checking Android project structure and configuration..."
echo ""

PROJECT_DIR=$(pwd)
echo "Working directory: $PROJECT_DIR"
echo ""

# Function to check if file exists
check_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo "✅ $description: $file exists"
        return 0
    else
        echo "❌ $description: $file missing"
        return 1
    fi
}

# Function to create root build.gradle
create_root_build_gradle() {
    echo "Creating root build.gradle..."
    cat > build.gradle << 'EOF'
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.2'
        classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.10'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF
    echo "✅ Created build.gradle"
}

# Function to create settings.gradle
create_settings_gradle() {
    echo "Creating settings.gradle..."
    
    # Detect project name from directory
    PROJECT_NAME=$(basename "$PROJECT_DIR")
    PROJECT_NAME_CAPITALIZED=$(echo "$PROJECT_NAME" | sed 's/\b\w/\U&/g')
    
    cat > settings.gradle << EOF
pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "$PROJECT_NAME_CAPITALIZED"
include ':app'
EOF
    echo "✅ Created settings.gradle with project name: $PROJECT_NAME_CAPITALIZED"
}

# Function to create gradle.properties
create_gradle_properties() {
    echo "Creating gradle.properties..."
    cat > gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
EOF
    echo "✅ Created gradle.properties"
}

# Function to check app/build.gradle compatibility
check_app_build_gradle() {
    if [ -f "app/build.gradle" ]; then
        echo "Checking app/build.gradle..."
        
        # Check if it uses new plugin syntax
        if grep -q "plugins {" app/build.gradle; then
            echo "✅ App uses modern plugin syntax"
            
            # Check for Android plugin
            if grep -q "id 'com.android.application'" app/build.gradle; then
                echo "✅ Android application plugin found"
            else
                echo "❌ Android application plugin missing"
                return 1
            fi
            
            # Check for compileSdk
            if grep -q "compileSdk" app/build.gradle; then
                COMPILE_SDK=$(grep "compileSdk" app/build.gradle | head -1 | grep -o '[0-9]\+')
                echo "✅ CompileSdk: $COMPILE_SDK"
            else
                echo "⚠️  CompileSdk not found"
            fi
            
        else
            echo "⚠️  App uses legacy plugin syntax - consider upgrading"
        fi
    else
        echo "❌ app/build.gradle not found"
        return 1
    fi
}

# Function to detect and fix project structure issues
fix_project_structure() {
    echo ""
    echo "=== Fixing Project Structure ==="
    
    FIXES_APPLIED=0
    
    # Check and fix root build.gradle
    if ! check_file "build.gradle" "Root build.gradle"; then
        create_root_build_gradle
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    fi
    
    # Check and fix settings.gradle
    if ! check_file "settings.gradle" "Settings gradle"; then
        create_settings_gradle
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    fi
    
    # Check and fix gradle.properties
    if ! check_file "gradle.properties" "Gradle properties"; then
        create_gradle_properties
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    fi
    
    # Check app directory
    if [ ! -d "app" ]; then
        echo "❌ app/ directory not found - this doesn't appear to be an Android project"
        exit 1
    else
        echo "✅ app/ directory exists"
    fi
    
    # Check app/build.gradle
    check_app_build_gradle
    
    echo ""
    if [ $FIXES_APPLIED -gt 0 ]; then
        echo "🔧 Applied $FIXES_APPLIED fixes"
        echo ""
        echo "=== Project should now be ready! ==="
        echo "Next steps:"
        echo "1. Run: source gradle_env.sh"
        echo "2. Test: ./gradlew tasks"
        echo "3. Build: ./gradlew assembleDebug"
    else
        echo "✅ No fixes needed - project structure looks good"
    fi
}

# Function to check environment
check_environment() {
    echo ""
    echo "=== Environment Check ==="
    
    if [ -f "gradle_env.sh" ]; then
        echo "✅ gradle_env.sh exists"
        echo "Environment variables will be:"
        grep "export" gradle_env.sh | sed 's/^/  /'
    else
        echo "❌ gradle_env.sh not found"
        echo "Run setupgradle.sh first to create the environment"
    fi
    
    if [ -f "gradlew" ]; then
        echo "✅ gradlew exists"
    else
        echo "❌ gradlew not found"
        echo "Run setupgradle.sh to download Gradle wrapper"
    fi
}

# Main execution
echo "Starting diagnostic..."
echo ""

# Check if we're in a project directory
if [ ! -f "app/build.gradle" ] && [ ! -f "build.gradle" ]; then
    echo "❌ This doesn't appear to be an Android project directory"
    echo "Expected to find either app/build.gradle or build.gradle"
    exit 1
fi

# Run diagnostics and fixes
fix_project_structure
check_environment

echo ""
echo "=== Diagnostic Complete ==="