#!/bin/bash
echo "Installing FUTO Keyboard APK..."
adb install -r ./build/outputs/apk/unstable/debug/latinime-unstable-debug.apk
echo "Opening FUTO Keyboard Settings..."
adb shell am start -n org.futo.inputmethod.latin.unstable/org.futo.inputmethod.latin.uix.settings.SettingsActivity
echo "Done! Settings should now be open on the emulator."
