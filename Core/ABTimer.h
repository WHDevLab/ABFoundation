//
//  ABTimer.h
//  ABFoundation
//
//  Created by qp on 2020/7/22.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABTimer : NSObject
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *tempTimer;
@property (nonatomic, weak) id tempTarget;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)tempTarget selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END
