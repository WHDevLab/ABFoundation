//
//  ABAudio.m
//  ABFoundation
//
//  Created by qp on 2020/7/2.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABAudio.h"
#import <AVFoundation/AVFoundation.h>
@interface ABAudio ()
@property (nonatomic, strong) AVAudioPlayer *player;
@end
@implementation ABAudio
+ (ABAudio *)shared {
    static ABAudio *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)playBundleFileWithName:(NSString *)name {
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (path == nil) {
        return;
    }
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    [_player prepareToPlay];
    [_player setVolume:1.0];
    [_player play];
}
@end
