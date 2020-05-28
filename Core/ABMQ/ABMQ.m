//
//  ABMQ.m
//  ABFoundation
//
//  Created by qp on 2020/5/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABMQ.h"
#import "ABMQSubscibe.h"
@interface ABMQ ()
@property (nonatomic, strong) NSMutableArray *subscribeObjs;
@end
@implementation ABMQ
- (void)subscribe:(id<ABMQSubscribeProtocol>)obj channel:(NSString *)channel autoAck:(BOOL)autoAck {
    [self subscribe:obj channels:@[channel] autoAck:autoAck];
}

- (void)subscribe:(id<ABMQSubscribeProtocol>)obj channels:(NSArray<NSString *> *)channels autoAck:(BOOL)autoAck {
    ABMQSubscibe *subscribe = [[ABMQSubscibe alloc] initWithTarget:obj];
    [self.subscribeObjs addObject:subscribe];
}

- (void)unsubscribe:(id<ABMQSubscribeProtocol>)obj channel:(NSString *)channel {
    [self unsubscribe:obj channels:@[channel]];
}

- (void)unsubscribe:(id<ABMQSubscribeProtocol>)obj channels:(NSArray<NSString *> *)channels {
    
}

- (void)unsubscribe:(id<ABMQSubscribeProtocol>)obj {
    @synchronized (self.subscribeObjs) {
        NSMutableArray *subscribeObjs = [[NSMutableArray alloc] init];
        [self.subscribeObjs enumerateObjectsUsingBlock:^(ABMQSubscibe *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.obj != obj) {
                [subscribeObjs addObject:obj];
            }
        }];
        self.subscribeObjs = subscribeObjs;
    }

}

- (void)publish:(id)message channel:(NSString *)channel {
    @synchronized (self.subscribeObjs) {
        for (ABMQSubscibe *subscribe in self.subscribeObjs) {
            if ([subscribe.channels containsObject:channel]) {
                [subscribe append:message];
            }
        }
    }
}

- (void)messageDistribute:(NSString *)channel {
    for (ABMQSubscibe *subscribe in self.subscribeObjs) {
        if ([subscribe.channels containsObject:channel]) {
            id message = [subscribe next];
            if (message) {
                [(id<ABMQSubscribeProtocol>)subscribe.obj onReceiveMessageFromMQ:message];
            }
        }
    }
}

@end
