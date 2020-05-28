//
//  ABMQSubscibe.m
//  ABFoundation
//
//  Created by qp on 2020/5/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABMQSubscibe.h"

@implementation ABMQSubscibe
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.quene = [[NSMutableArray alloc] init];
        self.channels = [[NSMutableArray alloc] init];
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

- (void)free:(BOOL)must {
    if (self.autoAck || must) {
        self.isFree = true;
    }
}

- (void)append:(id)message {
    [self.quene addObject:message];
}
@end
