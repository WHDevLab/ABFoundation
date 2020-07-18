//
//  ABMQSubscibe.m
//  ABFoundation
//
//  Created by qp on 2020/5/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABMQSubscibe.h"

@implementation ABMQSubscibe
- (instancetype)initWithTarget:(id)target
{
    self = [super initWithTarget:target];
    if (self) {
        self.quene = [[NSMutableArray alloc] init];
        self.channels = [[NSMutableArray alloc] init];
        self.isFree = true;
        self.autoAck = true;
    }
    return self;
}

- (id)next {
    if (self.isFree == false || self.quene.count == 0) {
        return nil;
    }
    self.isFree = false;
    return self.quene.lastObject;
}

- (void)pop {
    self.isFree = true;
    [self.quene removeLastObject];
}

- (void)free:(BOOL)must {
    if (self.autoAck || must) {
        self.isFree = true;
    }
}

- (void)append:(id)message channel:(NSString *)channel {
    [self.quene addObject:@{@"channel":channel, @"data":message}];
}
@end
