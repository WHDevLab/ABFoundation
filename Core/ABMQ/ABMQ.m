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

+ (ABMQ *)shared {
    static ABMQ *instance = nil;
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
        self.subscribeObjs = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)subscribe:(id<IABMQSubscribe>)obj channel:(NSString *)channel autoAck:(BOOL)autoAck {
    [self subscribe:obj channels:@[channel] autoAck:autoAck];
}

- (void)subscribe:(id<IABMQSubscribe>)obj channels:(NSArray<NSString *> *)channels autoAck:(BOOL)autoAck {
    ABMQSubscibe *subscribe = [[ABMQSubscibe alloc] initWithTarget:obj];
    subscribe.channels = [[NSMutableArray alloc] initWithArray:channels];
    subscribe.autoAck = autoAck;
    [self.subscribeObjs addObject:subscribe];
}

- (void)unsubscribe:(id<IABMQSubscribe>)obj channel:(NSString *)channel {
    [self unsubscribe:obj channels:@[channel]];
}

- (void)unsubscribe:(id<IABMQSubscribe>)obj channels:(NSArray<NSString *> *)channels {
    @synchronized (self.subscribeObjs) {
        [self.subscribeObjs enumerateObjectsUsingBlock:^(ABMQSubscibe *subscibe, NSUInteger idx, BOOL * _Nonnull stop) {
            if (subscibe.obj == obj) {
                NSMutableSet *set1 = [NSMutableSet setWithArray:subscibe.channels];
                NSMutableSet *set2 = [NSMutableSet setWithArray:channels];
                [set1 minusSet:set2];
                subscibe.channels = [[NSMutableArray alloc] initWithArray:[set1 allObjects]];
            }
        }];
    }
}

- (void)clearInvalid {
    @synchronized (self.subscribeObjs) {
        NSMutableArray *subscribeObjs = [[NSMutableArray alloc] init];
        [self.subscribeObjs enumerateObjectsUsingBlock:^(ABMQSubscibe *subscibe, NSUInteger idx, BOOL * _Nonnull stop) {
            if (subscibe.obj != nil) {
                [subscribeObjs addObject:subscibe];
            }
        }];
        self.subscribeObjs = subscribeObjs;
    }
}

- (void)unsubscribe:(id<IABMQSubscribe>)obj {
    @synchronized (self.subscribeObjs) {
        NSMutableArray *subscribeObjs = [[NSMutableArray alloc] init];
        [self.subscribeObjs enumerateObjectsUsingBlock:^(ABMQSubscibe *subscibe, NSUInteger idx, BOOL * _Nonnull stop) {
            if (subscibe.obj != obj) {
                [subscribeObjs addObject:subscibe];
            }
        }];
        self.subscribeObjs = subscribeObjs;
    }
}

- (void)publish:(id)message channel:(NSString *)channel {
    @synchronized (self.subscribeObjs) {
        for (ABMQSubscibe *subscribe in self.subscribeObjs) {
            if ([subscribe.channels containsObject:channel]) {
                [subscribe append:message channel:channel];
            }
        }
        
        [self messageDistribute];
    }
}

- (void)messageDistribute {
    [self clearInvalid];
    for (ABMQSubscibe *subscribe in self.subscribeObjs) {
        NSDictionary *message = [subscribe next];
        if (message != nil) {
            [(id<IABMQSubscribe>)subscribe.obj abmq:self onReceiveMessage:message[@"data"] channel:message[@"channel"]];
            [subscribe free:false];
        }
        
    }
}


- (void)ack:(id<IABMQSubscribe>)obj {
    [self.subscribeObjs enumerateObjectsUsingBlock:^(ABMQSubscibe *subscribe, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subscribe.obj == obj) {
            [subscribe pop];
        }
    }];
    
    [self messageDistribute];
}

@end
