#!/bin/bash

# Setup script for JUCE framework
echo "Setting up JUCE framework..."

# Create the juce directory if it doesn't exist
mkdir -p native/juce

# Change to the juce directory
cd native/juce

# Check if JUCE is already downloaded
if [ -d "JUCE" ]; then
    echo "JUCE already exists. Skipping download."
else
    echo "Downloading JUCE..."
    # Clone the JUCE repository
    git clone https://github.com/juce-framework/JUCE.git
    
    if [ $? -eq 0 ]; then
        echo "JUCE downloaded successfully!"
    else
        echo "Failed to download JUCE. Please check your internet connection."
        exit 1
    fi
fi

# Navigate to JUCE directory
cd JUCE

# Checkout a stable version (you can change this to a specific tag if needed)
git checkout master

echo "JUCE setup complete!"
echo "JUCE is located at: $(pwd)"

# Return to project root
cd ../../..

echo "Setup finished. You can now build the project." 