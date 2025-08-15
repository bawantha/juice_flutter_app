cmake_minimum_required(VERSION 3.18.1)

project("juce_flutter_native")

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add JUCE as a subdirectory (assuming JUCE is in the juce folder)
set(JUCE_BUILD_EXAMPLES OFF CACHE BOOL "Don't build JUCE examples")
set(JUCE_BUILD_EXTRAS OFF CACHE BOOL "Don't build JUCE extras")
add_subdirectory(../juce/JUCE JUCE)

# Include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../juce)

# Create the JNI library
add_library(juce_flutter_native SHARED
    jni_interface.cpp
    audio_processor.cpp
)

# Link libraries
target_link_libraries(juce_flutter_native
    juce::juce_audio_basics
    juce::juce_audio_devices
    juce::juce_audio_formats
    juce::juce_audio_processors
    juce::juce_audio_utils
    juce::juce_core
    juce::juce_data_structures
    juce::juce_events
    juce::juce_graphics
    juce::juce_gui_basics
    android
    log
)

# Compiler-specific options
target_compile_definitions(juce_flutter_native PRIVATE
    JUCE_WEB_BROWSER=0
    JUCE_USE_CURL=0
    JUCE_APPLICATION_NAME_STRING="$<TARGET_PROPERTY:juce_flutter_native,JUCE_APPLICATION_NAME_STRING>"
    JUCE_APPLICATION_VERSION_STRING="$<TARGET_PROPERTY:juce_flutter_native,JUCE_APPLICATION_VERSION_STRING>"
    JucePlugin_Build_VST=0
    JucePlugin_Build_VST3=0
    JucePlugin_Build_AU=0
    JucePlugin_Build_AUv3=0
    JucePlugin_Build_RTAS=0
    JucePlugin_Build_AAX=0
    JucePlugin_Build_Standalone=0
    JucePlugin_Enable_IAA=0
) 