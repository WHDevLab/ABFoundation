//
//  ABAudio.m
//  ABFoundation
//
//  Created by qp on 2020/7/2.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABAudio.h"
#import <AVFoundation/AVFoundation.h>
@interface ABAudio ()<AVAudioPlayerDelegate>
{
    NSRecursiveLock *_dataLock;
}
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *quenes;
@property (nonatomic, strong) NSMutableArray *runingQuenes;
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataLock = [[NSRecursiveLock alloc] init];
        self.quenes = [[NSMutableArray alloc] init];
        self.ismute = true;
    }
    return self;
}

- (void)playBundleFileWithMultipleName:(NSString *)multipleName {
    NSArray *names = [multipleName componentsSeparatedByString:@","];
    [self playBundleFileWithNames:names];
}

- (void)playBundleFileWithNames:(NSArray *)names {
    if (self.ismute) {
        return;
    }
    [_dataLock lock];
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    for (NSString *name in names) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        if (path != nil) {
            [paths addObject:path];
        }
    }
    
    if (paths.count == 0) {
        return;
    }
    [self.quenes addObjectsFromArray:paths];
    [_dataLock unlock];
    
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [self next];
}

- (void)playBundleFileWithName:(NSString *)name {
    if (self.ismute) {
        return;
    }
   NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
   if (path != nil) {
       [self _playWithPath:path];
   }
}

- (void)next {
    if (self.quenes.count == 0) {
        return;
    }
    
    [self _playWithPath:self.quenes.firstObject];
}

- (void)_playWithPath:(NSString *)path {
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    _player.delegate = self;
    [_player prepareToPlay];
    [_player setVolume:1.0];
    [_player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.quenes.count > 0) {
        [self.quenes removeObjectAtIndex:0];
    }
    [self next];
}

@end
