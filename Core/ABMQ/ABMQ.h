//
//  ABMQ.h
//  ABFoundation
//
//  Created by qp on 2020/5/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ABMQ;
@protocol IABMQSubscribe <NSObject>
- (void)abmq:(ABMQ *)abmq onReceiveMessage:(id)message channel:(NSString *)channel;
@end

@interface ABMQ : NSObject
+ (ABMQ *)shared;
- (void)subscribe:(id<IABMQSubscribe>)obj channel:(NSString *)channel autoAck:(BOOL)autoAck;
- (void)subscribe:(id<IABMQSubscribe>)obj channels:(NSArray<NSString *> *)channels autoAck:(BOOL)autoAck;
- (void)publish:(id)message channel:(NSString *)channel;
- (void)ack:(id<IABMQSubscribe>)obj;
@end

NS_ASSUME_NONNULL_END
