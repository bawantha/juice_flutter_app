import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var audioProcessor: AudioProcessor?
  private let CHANNEL = "com.example.juce_flutter_app/audio"
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let audioChannel = FlutterMethodChannel(name: CHANNEL,
                                          binaryMessenger: controller.binaryMessenger)
    
    audioChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      self.handleMethodCall(call: call, result: result)
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initializeAudio":
      if audioProcessor == nil {
        audioProcessor = AudioProcessor()
      }
      let success = audioProcessor?.initialize() ?? false
      result(success)
      
    case "startAudio":
      audioProcessor?.start()
      result(nil)
      
    case "stopAudio":
      audioProcessor?.stop()
      result(nil)
      
    case "releaseAudio":
      audioProcessor?.release()
      audioProcessor = nil
      result(nil)
      
    case "setVolume":
      if let args = call.arguments as? [String: Any],
         let volume = args["volume"] as? Double {
        audioProcessor?.setVolume(Float(volume))
      }
      result(nil)
      
    case "setFrequency":
      if let args = call.arguments as? [String: Any],
         let frequency = args["frequency"] as? Double {
        audioProcessor?.setFrequency(Float(frequency))
      }
      result(nil)
      
    case "isAudioPlaying":
      let playing = audioProcessor?.isPlaying() ?? false
      result(playing)
      
    case "getCurrentVolume":
      let volume = audioProcessor?.getVolume() ?? 0.0
      result(Double(volume))
      
    case "getCurrentFrequency":
      let frequency = audioProcessor?.getFrequency() ?? 440.0
      result(Double(frequency))
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
