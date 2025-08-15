import 'package:flutter/services.dart';

class AudioService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.juce_flutter_app/audio',
  );

  /// Initialize the audio system
  static Future<bool> initialize() async {
    try {
      final bool result = await _channel.invokeMethod('initializeAudio');
      return result;
    } on PlatformException catch (e) {
      print("Failed to initialize audio: '${e.message}'.");
      return false;
    }
  }

  /// Start audio playback
  static Future<void> start() async {
    try {
      await _channel.invokeMethod('startAudio');
    } on PlatformException catch (e) {
      print("Failed to start audio: '${e.message}'.");
    }
  }

  /// Stop audio playback
  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stopAudio');
    } on PlatformException catch (e) {
      print("Failed to stop audio: '${e.message}'.");
    }
  }

  /// Release audio resources
  static Future<void> release() async {
    try {
      await _channel.invokeMethod('releaseAudio');
    } on PlatformException catch (e) {
      print("Failed to release audio: '${e.message}'.");
    }
  }

  /// Set the volume (0.0 to 1.0)
  static Future<void> setVolume(double volume) async {
    try {
      await _channel.invokeMethod('setVolume', {'volume': volume});
    } on PlatformException catch (e) {
      print("Failed to set volume: '${e.message}'.");
    }
  }

  /// Set the frequency in Hz
  static Future<void> setFrequency(double frequency) async {
    try {
      await _channel.invokeMethod('setFrequency', {'frequency': frequency});
    } on PlatformException catch (e) {
      print("Failed to set frequency: '${e.message}'.");
    }
  }

  /// Check if audio is currently playing
  static Future<bool> isPlaying() async {
    try {
      final bool result = await _channel.invokeMethod('isAudioPlaying');
      return result;
    } on PlatformException catch (e) {
      print("Failed to check playing status: '${e.message}'.");
      return false;
    }
  }

  /// Get current volume
  static Future<double> getCurrentVolume() async {
    try {
      final double result = await _channel.invokeMethod('getCurrentVolume');
      return result;
    } on PlatformException catch (e) {
      print("Failed to get current volume: '${e.message}'.");
      return 0.0;
    }
  }

  /// Get current frequency
  static Future<double> getCurrentFrequency() async {
    try {
      final double result = await _channel.invokeMethod('getCurrentFrequency');
      return result;
    } on PlatformException catch (e) {
      print("Failed to get current frequency: '${e.message}'.");
      return 440.0;
    }
  }
}
