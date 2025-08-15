# JUCE Flutter Audio App

A Flutter mobile application that integrates with the JUCE C++ audio framework through JNI (Java Native Interface) for high-performance audio processing. This project demonstrates how to build a cross-platform mobile audio application with native-level audio processing capabilities.

## Features

- 🎵 **Real-time Audio Generation**: Generate sine waves with adjustable frequency and volume
- 🎛️ **Interactive Controls**: Beautiful Material 3 UI with responsive sliders and animated controls
- 🔧 **Native Performance**: Uses JUCE C++ framework for low-latency audio processing
- 📱 **Cross-Platform**: Supports both Android and iOS platforms
- 🎨 **Modern UI**: Dark theme with gradient backgrounds and smooth animations

## Architecture

The app uses a multi-layered architecture:

```
┌─────────────────────────────────────┐
│           Flutter UI Layer          │
│     (Dart - Material 3 Design)     │
├─────────────────────────────────────┤
│        Platform Channel Layer      │
│      (Method Channel Bridge)       │
├─────────────────────────────────────┤
│        Native Platform Layer       │
│   Android: JNI + Kotlin/Java       │
│   iOS: Objective-C++               │
├─────────────────────────────────────┤
│         JUCE Audio Layer           │
│      (C++ Audio Processing)        │
└─────────────────────────────────────┘
```

## Prerequisites

Before building this project, ensure you have:

- **Flutter SDK** (3.0 or later)
- **Android Studio** with NDK installed
- **Xcode** (for iOS development)
- **Git** (to download JUCE)
- **CMake** (3.18.1 or later)

## Setup Instructions

### 1. Clone and Initialize

```bash
# Navigate to your projects directory
cd /path/to/your/projects

# The project is already created as juce_flutter_app
cd juce_flutter_app

# Make the setup script executable and run it
chmod +x setup_juce.sh
./setup_juce.sh
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Platform-Specific Setup

#### Android Setup

1. **NDK Configuration**: Ensure Android NDK is installed via Android Studio
2. **CMake**: The project uses CMake for native code compilation
3. **Minimum SDK**: Set to API level 21 (Android 5.0)

#### iOS Setup

1. **Xcode**: Open `ios/Runner.xcworkspace`
2. **Deployment Target**: Set to iOS 11.0 or later
3. **Signing**: Configure your development team for code signing

### 4. Build and Run

```bash
# For Android
flutter run

# For iOS (requires macOS and Xcode)
flutter run -d ios
```

## Project Structure

```
juce_flutter_app/
├── lib/
│   ├── main.dart              # Main Flutter application
│   └── audio_service.dart     # Platform channel service
├── native/
│   ├── juce/                  # JUCE framework (downloaded by setup script)
│   ├── android/
│   │   ├── CMakeLists.txt     # Android native build configuration
│   │   ├── jni_interface.cpp  # JNI bridge implementation
│   │   ├── audio_processor.h  # Audio processor header
│   │   └── audio_processor.cpp # Audio processor implementation
│   └── ios/
│       ├── AudioProcessor.h   # iOS Objective-C++ header
│       └── AudioProcessor.mm  # iOS Objective-C++ implementation
├── android/
│   └── app/
│       ├── build.gradle.kts   # Android build configuration
│       └── src/main/kotlin/com/example/juce_flutter_app/
│           └── MainActivity.kt # Android platform channel handler
├── ios/
│   └── Runner/
│       └── AppDelegate.swift  # iOS platform channel handler
└── setup_juce.sh             # JUCE framework setup script
```

## Technical Details

### Native Audio Processing

The app uses JUCE's `AudioIODeviceCallback` interface to generate real-time audio:

- **Sample Rate**: Adapts to device capabilities (typically 44.1kHz)
- **Audio Format**: 32-bit floating point
- **Channels**: Stereo output
- **Latency**: Low-latency audio processing through JUCE

### Platform Channels

Communication between Flutter and native code uses method channels:

**Channel Name**: `com.example.juce_flutter_app/audio`

**Available Methods**:
- `initializeAudio()` → `bool`
- `startAudio()` → `void`
- `stopAudio()` → `void`
- `releaseAudio()` → `void`
- `setVolume(double volume)` → `void`
- `setFrequency(double frequency)` → `void`
- `isAudioPlaying()` → `bool`
- `getCurrentVolume()` → `double`
- `getCurrentFrequency()` → `double`

### JUCE Integration

The project integrates these JUCE modules:
- `juce_audio_basics`
- `juce_audio_devices`
- `juce_audio_formats`
- `juce_audio_processors`
- `juce_audio_utils`
- `juce_core`
- `juce_data_structures`
- `juce_events`

## Troubleshooting

### Common Issues

1. **JUCE Not Found**: Run `./setup_juce.sh` to download JUCE framework
2. **NDK Errors**: Ensure Android NDK is installed and CMake version is 3.18.1+
3. **iOS Build Issues**: Check Xcode project settings and signing configuration
4. **Audio Not Playing**: Verify device audio permissions and initialization status

### Build Errors

- **CMake Version**: Ensure CMake 3.18.1 or later is installed
- **Missing Headers**: Verify JUCE is properly downloaded in `native/juce/JUCE`
- **Linking Errors**: Check that all JUCE modules are properly linked in CMakeLists.txt

## Performance Considerations

- **Thread Safety**: Audio processing runs on dedicated audio threads
- **Memory Management**: Uses smart pointers for safe resource management
- **Real-time Safety**: Avoids memory allocation in audio callbacks
- **Platform Optimization**: Native code optimized for each platform

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [JUCE Framework](https://github.com/juce-framework/JUCE) - Audio application framework
- [Flutter](https://flutter.dev) - Cross-platform UI toolkit
- Material 3 Design System - Modern UI components

## Resources

- [JUCE Documentation](https://docs.juce.com/)
- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Android NDK Guide](https://developer.android.com/ndk/guides)
- [iOS Native Code Integration](https://docs.flutter.dev/development/platform-integration/ios/c-interop)
