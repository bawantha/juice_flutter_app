#import "AudioProcessor.h"
#include "../android/audio_processor.h"
#include <memory>

@interface AudioProcessor()
@property (nonatomic) std::unique_ptr<::AudioProcessor> cppAudioProcessor;
@end

@implementation AudioProcessor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cppAudioProcessor = std::make_unique<::AudioProcessor>();
    }
    return self;
}

- (BOOL)initialize {
    if (self.cppAudioProcessor) {
        return self.cppAudioProcessor->initialize() ? YES : NO;
    }
    return NO;
}

- (void)start {
    if (self.cppAudioProcessor) {
        self.cppAudioProcessor->start();
    }
}

- (void)stop {
    if (self.cppAudioProcessor) {
        self.cppAudioProcessor->stop();
    }
}

- (BOOL)isPlaying {
    if (self.cppAudioProcessor) {
        return self.cppAudioProcessor->isPlaying() ? YES : NO;
    }
    return NO;
}

- (void)setVolume:(float)volume {
    if (self.cppAudioProcessor) {
        self.cppAudioProcessor->setVolume(volume);
    }
}

- (float)getVolume {
    if (self.cppAudioProcessor) {
        return self.cppAudioProcessor->getVolume();
    }
    return 0.0f;
}

- (void)setFrequency:(float)frequency {
    if (self.cppAudioProcessor) {
        self.cppAudioProcessor->setFrequency(frequency);
    }
}

- (float)getFrequency {
    if (self.cppAudioProcessor) {
        return self.cppAudioProcessor->getFrequency();
    }
    return 440.0f;
}

- (void)release {
    self.cppAudioProcessor.reset();
}

@end 