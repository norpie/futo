# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FUTO Keyboard is an Android virtual keyboard application forked from LatinIME (Android Open Source Project). It's a privacy-focused keyboard that stays offline and includes voice input capabilities. The project is licensed under FUTO Source First License 1.1.

## Build System & Commands

### Development Environment Setup
```bash
# Option 1: Using Nix flake (recommended for reproducible builds)
nix develop

# Option 2: Using direnv for automatic environment loading
direnv allow

# Verify submodules are initialized
git submodule update --init --recursive
```

### Core Build Commands
```bash
# Build debug version (default unstable flavor)
./gradlew assembleUnstableDebug

# Build release version (stable flavor)
./gradlew assembleStableRelease

# Run Android instrumented tests
./gradlew connectedAndroidTest

# List all available tasks
./gradlew tasks
```

### Product Flavors
- `unstable`: Development/beta builds with .unstable suffix
- `stable`: Production builds
- `playstore`: Google Play Store specific builds with .playstore suffix

### Gradle Tasks
```bash
# Update locale files
./gradlew updateLocales

# Update contributor list (requires GITHUB_TOKEN env var)
./gradlew updateContributors
```

### Native Code Testing
```bash
# Run native JNI unit tests (requires Android build environment)
cd native/jni && ./run-tests.sh --host

# Run dictionary toolkit tests
cd native/dicttoolkit && ./run_tests.sh
```

## Code Architecture

### Main Package Structure
- `org.futo.inputmethod.latin`: Core IME functionality
- `org.futo.inputmethod.keyboard`: Keyboard rendering and touch handling  
- `org.futo.inputmethod.v2keyboard`: New keyboard layout system
- `org.futo.inputmethod.uix`: Modern UI components built with Compose
- `org.futo.voiceinput.shared`: Voice input functionality (separate module)

### Key Components

#### Core IME (java/src/org/futo/inputmethod/latin/)
- `LatinIME.kt`: Main input method service implementation
- `InputLogic.java`: Text input processing and suggestion handling
- `DictionaryFacilitator.java`: Dictionary management and word prediction
- `Suggest.java`: Suggestion generation engine
- `RichInputConnection.java`: Enhanced text field interaction

#### Keyboard System (java/src/org/futo/inputmethod/keyboard/)
- `KeyboardSwitcher.java`: Manages keyboard layout switching
- `MainKeyboardView.java`: Primary keyboard rendering
- `PointerTracker.java`: Touch event processing
- `Key.kt` & `Keyboard.java`: Key and keyboard data structures

#### Modern UI (java/src/org/futo/inputmethod/uix/)
- Built with Jetpack Compose for settings and actions
- `SettingsActivity.kt`: Main settings interface
- `UixManager.kt`: Coordinates between legacy and modern UI
- Theme system with customizable color schemes and effects

#### V2 Keyboard System (java/src/org/futo/inputmethod/v2keyboard/)
- Next-generation keyboard layout engine
- `LayoutEngine.kt`: Processes YAML layout definitions  
- `KeyboardLayoutSet.kt`: Manages multiple keyboard layouts
- `LayoutManager.kt`: Runtime layout switching

#### Native Code (native/jni/src/)
- Dictionary processing and word prediction algorithms
- Language model integration (XLM)
- Gesture recognition and input processing
- Voice input integration (Whisper GGML)

### Build Configuration
- Uses Android Gradle Plugin 8.10.1
- Kotlin 2.1.0 with Compose integration
- Minimum SDK 24, Target SDK 35
- NDK version 28.2.13676358 for native components
- CMake build system for C++ code

### Testing Structure
- Android instrumented tests in `tests/` directory
- Native unit tests for JNI components
- Keyboard layout and action tests
- Compatibility utility tests

### Dependencies
- Jetpack Compose for modern UI
- TensorFlow Lite for ML models
- AndroidX libraries for compatibility
- ACRA for crash reporting (stable builds only)
- Custom native libraries for voice processing

## Development Environment Requirements
- Java 8+ (JDK 17 recommended)
- Android SDK with API levels 24-35
- Android NDK 28.2.13676358
- CMake for native builds
- Python 3 with requests library (for build scripts)
- Git (for version info and submodules)

## Key Development Notes
- Mixed Java/Kotlin codebase with ongoing Kotlin migration
- Heavy use of JNI for performance-critical components
- Complex keyboard layout system supporting multiple languages
- Voice input requires separate licensing and payment integration
- Extensive internationalization support via Pontoon translations
- Build warnings about experimental AAPT2 settings are normal
- Missing keystore.properties and crashreporting.properties files are expected for development builds