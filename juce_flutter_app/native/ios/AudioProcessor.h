#import <Foundation/Foundation.h>

@interface AudioProcessor : NSObject

- (instancetype)init;
- (BOOL)initialize;
- (void)start;
- (void)stop;
- (BOOL)isPlaying;
- (void)setVolume:(float)volume;
- (float)getVolume;
- (void)setFrequency:(float)frequency;
- (float)getFrequency;
- (void)release;

@end 