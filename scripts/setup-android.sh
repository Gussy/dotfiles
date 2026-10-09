#!/bin/bash

set -e

ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"
ANDROID_PACKAGES=(
    "platform-tools"
    "platforms;android-35"
    "build-tools;35.0.0"
    "ndk;27.0.12077973"
)

echo "🤖 Setting up Android toolchain..."

if ! command -v sdkmanager &> /dev/null; then
    echo "⚠️  sdkmanager not found. Install Homebrew cask 'android-commandlinetools' first."
    exit 1
fi

if /usr/libexec/java_home -v 17 > /dev/null 2>&1; then
    export JAVA_HOME="$("/usr/libexec/java_home" -v 17)"
    echo "✅ Using JDK 17 at $JAVA_HOME"
else
    echo "⚠️  JDK 17 not found. Install Homebrew cask 'temurin@17' first."
    exit 1
fi

export ANDROID_HOME="$ANDROID_SDK_ROOT"
export ANDROID_SDK_ROOT
mkdir -p "$ANDROID_SDK_ROOT"

echo "Accepting Android SDK licenses..."
yes | sdkmanager --sdk_root="$ANDROID_SDK_ROOT" --licenses > /dev/null

echo "Installing Android SDK packages into $ANDROID_SDK_ROOT..."
sdkmanager --sdk_root="$ANDROID_SDK_ROOT" "${ANDROID_PACKAGES[@]}"

echo "✅ Android SDK ready"
