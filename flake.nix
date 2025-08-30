{
  description = "Development environment for FUTO Keyboard (LatinIME)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, android-nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      android-sdk = android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
        # Build tools and platform tools
        cmdline-tools-latest
        platform-tools
        tools
        
        # Android platforms
        platforms-android-35  # compileSdk
        platforms-android-34
        platforms-android-33
        platforms-android-24  # minSdk
        
        # Build tools versions
        build-tools-35-0-0
        build-tools-34-0-0
        build-tools-33-0-2
        
        # NDK for native components (version 28.2.13676358 equivalent)
        ndk-28-2-13676358
        
        # Additional components
        emulator
        system-images-android-35-google-apis-x86-64
        cmake-3-22-1
        
        # Support libraries
        sources-android-35
        sources-android-34
        
        # Google Play services (for playstore flavor)
        extras-google-google-play-services
        extras-google-m2repository
        extras-android-m2repository
      ]);

    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Android development
          android-sdk
          
          # Java (required for Gradle and Android development)
          jdk17  # Modern JDK, compatible with Gradle and Android
          
          # Python for build scripts
          python3
          python3Packages.requests  # For contributors.py
          python3Packages.pyyaml    # For YAML parsing in layouts
          
          # Build tools
          gradle_8  # Use Gradle 8 which is compatible with the project
          cmake
          ninja
          
          # Version control and utilities
          git
          which
          file
          unzip
          
          # Native development
          gcc
          gnumake
          pkg-config
          
          # Optional: Android Studio alternative
          # android-studio  # Uncomment if you prefer Android Studio
        ];

        shellHook = ''
          # Set up Android SDK environment
          export ANDROID_HOME="${android-sdk}/share/android-sdk"
          export ANDROID_SDK_ROOT="$ANDROID_HOME"
          export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/28.2.13676358"
          export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
          
          # Set up Gradle
          export GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=$ANDROID_HOME/build-tools/35.0.0/aapt2"
          
          # Java environment
          export JAVA_HOME="${pkgs.jdk17}"
          
          # CMake for native builds
          export CMAKE_PREFIX_PATH="${pkgs.cmake}"
          
          # Git configuration for version info
          export PATH="${pkgs.git}/bin:$PATH"
          
          echo "🚀 FUTO Keyboard development environment ready!"
          echo ""
          echo "Available commands:"
          echo "  ./gradlew assembleUnstableDebug    - Build debug APK"
          echo "  ./gradlew assembleStableRelease    - Build release APK"
          echo "  ./gradlew updateLocales            - Update locale files"
          echo "  ./gradlew updateContributors       - Update contributors list"
          echo "  ./gradlew connectedAndroidTest     - Run Android tests"
          echo ""
          echo "Environment:"
          echo "  ANDROID_HOME: $ANDROID_HOME"
          echo "  ANDROID_NDK_ROOT: $ANDROID_NDK_ROOT"
          echo "  JAVA_HOME: $JAVA_HOME"
          echo ""
          
          # Verify Android SDK installation
          if [ -x "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
            echo "✅ Android SDK ready"
          else
            echo "❌ Android SDK not properly configured"
          fi
          
          # Verify NDK installation
          if [ -d "$ANDROID_NDK_ROOT" ]; then
            echo "✅ Android NDK ready"
          else
            echo "❌ Android NDK not found"
          fi
          
          # Verify Java installation
          if java -version 2>&1 | grep -q "openjdk version"; then
            echo "✅ Java ready"
          else
            echo "❌ Java not properly configured"
          fi
          
          echo ""
          echo "To get started:"
          echo "  1. Run 'git submodule update --init --recursive' if not done already"
          echo "  2. Run './gradlew assembleUnstableDebug' to build a debug APK"
        '';

        # Prevent Gradle from trying to download its own Android SDK
        ANDROID_HOME = "${android-sdk}/share/android-sdk";
        ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";
        ANDROID_NDK_ROOT = "${android-sdk}/share/android-sdk/ndk/28.2.13676358";
        JAVA_HOME = pkgs.jdk17;
      };

      # Provide a formatter for the flake
      formatter.${system} = pkgs.nixpkgs-fmt;
      
      # Package outputs (optional - for building the APK with Nix)
      packages.${system} = {
        # Could add a package to build the APK directly with Nix
        # This would be more complex and might not be necessary for development
      };
    };
}