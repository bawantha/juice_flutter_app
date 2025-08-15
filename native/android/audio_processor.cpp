#include "audio_processor.h"
#include <cmath>

AudioProcessor::AudioProcessor()
    : deviceManager(std::make_unique<juce::AudioDeviceManager>())
{
}

AudioProcessor::~AudioProcessor()
{
    if (playing.load())
    {
        stop();
    }
}

bool AudioProcessor::initialize()
{
    // Initialize the audio device manager
    juce::String error = deviceManager->initialise(0, 2, nullptr, true);
    if (error.isNotEmpty())
    {
        return false;
    }
    
    // Set up the audio device callback
    deviceManager->addAudioCallback(this);
    
    return true;
}

void AudioProcessor::start()
{
    if (!playing.load())
    {
        playing.store(true);
        updatePhaseIncrement();
    }
}

void AudioProcessor::stop()
{
    playing.store(false);
}

bool AudioProcessor::isPlaying() const
{
    return playing.load();
}

void AudioProcessor::setVolume(float newVolume)
{
    // Clamp volume between 0.0 and 1.0
    volume.store(juce::jlimit(0.0f, 1.0f, newVolume));
}

float AudioProcessor::getVolume() const
{
    return volume.load();
}

void AudioProcessor::setFrequency(float newFrequency)
{
    // Clamp frequency between 20Hz and 20kHz
    frequency.store(juce::jlimit(20.0f, 20000.0f, newFrequency));
    updatePhaseIncrement();
}

float AudioProcessor::getFrequency() const
{
    return frequency.load();
}

void AudioProcessor::audioDeviceIOCallbackWithContext(const float* const* inputChannelData,
                                                    int numInputChannels,
                                                    float* const* outputChannelData,
                                                    int numOutputChannels,
                                                    int numSamples,
                                                    const juce::AudioIODeviceCallbackContext& context)
{
    // Clear output buffers first
    for (int channel = 0; channel < numOutputChannels; ++channel)
    {
        juce::FloatVectorOperations::clear(outputChannelData[channel], numSamples);
    }
    
    if (!playing.load())
        return;
    
    const float currentVolume = volume.load();
    const float currentFrequency = frequency.load();
    
    // Generate sine wave
    for (int sample = 0; sample < numSamples; ++sample)
    {
        const float sineValue = std::sin(currentPhase) * currentVolume;
        
        // Write to all output channels
        for (int channel = 0; channel < numOutputChannels; ++channel)
        {
            outputChannelData[channel][sample] = sineValue;
        }
        
        // Update phase
        currentPhase += phaseIncrement;
        if (currentPhase >= juce::MathConstants<double>::twoPi)
        {
            currentPhase -= juce::MathConstants<double>::twoPi;
        }
    }
}

void AudioProcessor::audioDeviceAboutToStart(juce::AudioIODevice* device)
{
    currentSampleRate = device->getCurrentSampleRate();
    updatePhaseIncrement();
    currentPhase = 0.0;
}

void AudioProcessor::audioDeviceStopped()
{
    currentPhase = 0.0;
}

void AudioProcessor::updatePhaseIncrement()
{
    const double freq = static_cast<double>(frequency.load());
    phaseIncrement = freq * juce::MathConstants<double>::twoPi / currentSampleRate;
} 