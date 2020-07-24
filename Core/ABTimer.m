//
//  ABTimer.m
//  ABFoundation
//
//  Created by qp on 2020/7/22.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABTimer.h"

@implementation ABTimer
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)tempTarget selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats {
    ABTimer *target = [[ABTimer alloc] init];
    target.tempTarget = tempTarget;
    target.selector = selector;
    target.tempTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:target selector:@selector(timerSelector:) userInfo:userInfo repeats:repeats];
    return target.tempTimer;
}

- (void)timerSelector:(NSTimer *)tempTimer {
    if (self.tempTarget && [self.tempTarget respondsToSelector:self.selector]) {
        [self.tempTarget performSelector:self.selector withObject:tempTimer.userInfo];
    }else {
        [self.tempTimer invalidate];
    }
}
@end
