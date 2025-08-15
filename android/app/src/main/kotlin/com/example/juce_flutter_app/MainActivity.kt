package com.example.juce_flutter_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    
    companion object {
        private const val CHANNEL = "com.example.juce_flutter_app/audio"
        
        init {
            System.loadLibrary("juce_flutter_native")
        }
    }
    
    // Native method declarations
    external fun initializeAudio(): Boolean
    external fun startAudio()
    external fun stopAudio()
    external fun releaseAudio()
    external fun setVolume(volume: Float)
    external fun setFrequency(frequency: Float)
    external fun isAudioPlaying(): Boolean
    external fun getCurrentVolume(): Float
    external fun getCurrentFrequency(): Float
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeAudio" -> {
                    val success = initializeAudio()
                    result.success(success)
                }
                "startAudio" -> {
                    startAudio()
                    result.success(null)
                }
                "stopAudio" -> {
                    stopAudio()
                    result.success(null)
                }
                "releaseAudio" -> {
                    releaseAudio()
                    result.success(null)
                }
                "setVolume" -> {
                    val volume = call.argument<Double>("volume")?.toFloat() ?: 0.5f
                    setVolume(volume)
                    result.success(null)
                }
                "setFrequency" -> {
                    val frequency = call.argument<Double>("frequency")?.toFloat() ?: 440.0f
                    setFrequency(frequency)
                    result.success(null)
                }
                "isAudioPlaying" -> {
                    val playing = isAudioPlaying()
                    result.success(playing)
                }
                "getCurrentVolume" -> {
                    val volume = getCurrentVolume()
                    result.success(volume.toDouble())
                }
                "getCurrentFrequency" -> {
                    val frequency = getCurrentFrequency()
                    result.success(frequency.toDouble())
                }
                else -> result.notImplemented()
            }
        }
    }
}
