# FUTO Keyboard (norpie Fork)

> **⚠️ FORK NOTICE:** This is a personal fork of FUTO Keyboard with experimental ortholinear QWERTY layout and swipe gesture features. For the official FUTO Keyboard, visit [futo-org/android-keyboard](https://github.com/futo-org/android-keyboard).

The goal is to make a good modern keyboard that stays offline and doesn't spy on you. This keyboard is a fork of [LatinIME, The Android Open-Source Keyboard](https://android.googlesource.com/platform/packages/inputmethods/LatinIME), with significant changes made to it.

Check out the [FUTO Keyboard website](https://keyboard.futo.org/) for downloads and more information.

The code is licensed under the [FUTO Source First License 1.1](LICENSE.md).

## 🆕 Ortholinear QWERTY Features (Experimental)

This fork includes experimental ortholinear QWERTY layout with gesture-based controls:

### ✨ New Features
- **Ortholinear QWERTY Layout**: 10-column grid layout for improved ergonomics
- **Swipe Up Gesture**: Activates shift for the next character typed
- **Swipe Left Gesture**: Smart delete (character normally, word when shifted)
- **Gesture-Based Input**: No physical shift/delete keys for cleaner interface

### 🎮 How to Use Gestures
- **Touch any key** and **swipe up** → Next character will be capitalized
- **Touch any key** and **swipe left** → Delete single character
- **Swipe up + swipe left** → Delete entire word
- **Regular tap** → Type the letter normally

### ⚠️ Experimental Status
These features are experimental and may have bugs. The ortholinear layout may not work perfectly with all apps or input fields.

## Issue tracking and contributing

This is a personal fork for experimental features. For issues with the official FUTO Keyboard:
- **Official Repository**: [futo-org/android-keyboard](https://github.com/futo-org/android-keyboard)
- **Official Issues**: [GitHub Issues](https://github.com/futo-org/android-keyboard/issues)

For issues with this experimental fork:
- **Fork Repository**: [norpie/futo](https://github.com/norpie/futo)
- **Layouts Repository**: [norpie/futo-layouts](https://github.com/norpie/futo-layouts)

The original FUTO Keyboard source is hosted on [internal GitLab](https://gitlab.futo.org/keyboard/latinime) and mirrored to [GitHub](https://github.com/futo-org/android-keyboard/).

Due to custom license, pull requests to the official repository require signing a [CLA](https://cla.futo.org/). Contributions to the [layouts repo](https://github.com/futo-org/futo-keyboard-layouts) don't require CLA as they're Apache-2.0.

## Layouts

This fork uses a separate layouts repository for keyboard layout definitions:
- **Fork Layouts**: [norpie/futo-layouts](https://github.com/norpie/futo-layouts)
- **Official Layouts**: [futo-org/futo-keyboard-layouts](https://github.com/futo-org/futo-keyboard-layouts)

The ortholinear QWERTY layout is defined in the `Default/qwerty.yaml` file in the layouts repository.

## Building

When cloning this repository, you must perform a recursive clone to fetch all dependencies:
```bash
git clone --recursive https://github.com/norpie/futo.git
```

If you forgot to specify recursive clone, use this to fetch submodules:
```bash
git submodule update --init --recursive
```

You can then open the project in Android Studio and build it that way, or use gradle commands:
```bash
./gradlew assembleUnstableDebug
./gradlew assembleStableRelease
```

### Building with Ortholinear Features

The ortholinear QWERTY layout and swipe gestures are automatically included when building the `unstable` flavor. The features will be available in the keyboard settings once installed.

### Testing the Ortholinear Layout

1. Install the built APK on your device/emulator
2. Open any app with text input
3. The ortholinear QWERTY should be available as a keyboard option
4. Try the swipe gestures:
   - Swipe up on any key to activate shift
   - Swipe left on any key to delete
   - Swipe up then swipe left to delete entire words