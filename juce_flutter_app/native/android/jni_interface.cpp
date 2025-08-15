#include <jni.h>
#include <android/log.h>
#include <string>
#include <memory>
#include "audio_processor.h"

#define LOG_TAG "JuceFlutterNative"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

static std::unique_ptr<AudioProcessor> audioProcessor;

extern "C" {

JNIEXPORT jboolean JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_initializeAudio(JNIEnv *env, jobject thiz) {
    LOGI("Initializing audio processor");
    try {
        audioProcessor = std::make_unique<AudioProcessor>();
        return audioProcessor->initialize() ? JNI_TRUE : JNI_FALSE;
    } catch (const std::exception& e) {
        LOGE("Failed to initialize audio processor: %s", e.what());
        return JNI_FALSE;
    }
}

JNIEXPORT void JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_startAudio(JNIEnv *env, jobject thiz) {
    LOGI("Starting audio");
    if (audioProcessor) {
        audioProcessor->start();
    }
}

JNIEXPORT void JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_stopAudio(JNIEnv *env, jobject thiz) {
    LOGI("Stopping audio");
    if (audioProcessor) {
        audioProcessor->stop();
    }
}

JNIEXPORT void JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_releaseAudio(JNIEnv *env, jobject thiz) {
    LOGI("Releasing audio processor");
    audioProcessor.reset();
}

JNIEXPORT void JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_setVolume(JNIEnv *env, jobject thiz, jfloat volume) {
    LOGI("Setting volume to %f", volume);
    if (audioProcessor) {
        audioProcessor->setVolume(volume);
    }
}

JNIEXPORT void JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_setFrequency(JNIEnv *env, jobject thiz, jfloat frequency) {
    LOGI("Setting frequency to %f", frequency);
    if (audioProcessor) {
        audioProcessor->setFrequency(frequency);
    }
}

JNIEXPORT jboolean JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_isAudioPlaying(JNIEnv *env, jobject thiz) {
    if (audioProcessor) {
        return audioProcessor->isPlaying() ? JNI_TRUE : JNI_FALSE;
    }
    return JNI_FALSE;
}

JNIEXPORT jfloat JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_getCurrentVolume(JNIEnv *env, jobject thiz) {
    if (audioProcessor) {
        return audioProcessor->getVolume();
    }
    return 0.0f;
}

JNIEXPORT jfloat JNICALL
Java_com_example_juce_1flutter_1app_MainActivity_getCurrentFrequency(JNIEnv *env, jobject thiz) {
    if (audioProcessor) {
        return audioProcessor->getFrequency();
    }
    return 440.0f;
}

} 