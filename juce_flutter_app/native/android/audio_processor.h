#pragma once

#include <juce_audio_basics/juce_audio_basics.h>
#include <juce_audio_devices/juce_audio_devices.h>
#include <juce_audio_formats/juce_audio_formats.h>
#include <juce_audio_processors/juce_audio_processors.h>
#include <juce_core/juce_core.h>
#include <memory>
#include <atomic>

class AudioProcessor : public juce::AudioIODeviceCallback
{
public:
    AudioProcessor();
    ~AudioProcessor();
    
    bool initialize();
    void start();
    void stop();
    bool isPlaying() const;
    
    void setVolume(float volume);
    float getVolume() const;
    
    void setFrequency(float frequency);
    float getFrequency() const;
    
    // AudioIODeviceCallback interface
    void audioDeviceIOCallbackWithContext(const float* const* inputChannelData,
                                        int numInputChannels,
                                        float* const* outputChannelData,
                                        int numOutputChannels,
                                        int numSamples,
                                        const juce::AudioIODeviceCallbackContext& context) override;
    
    void audioDeviceAboutToStart(juce::AudioIODevice* device) override;
    void audioDeviceStopped() override;

private:
    std::unique_ptr<juce::AudioDeviceManager> deviceManager;
    
    std::atomic<float> volume{0.5f};
    std::atomic<float> frequency{440.0f};
    std::atomic<bool> playing{false};
    
    double currentSampleRate{44100.0};
    double currentPhase{0.0};
    double phaseIncrement{0.0};
    
    void updatePhaseIncrement();
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(AudioProcessor)
}; 