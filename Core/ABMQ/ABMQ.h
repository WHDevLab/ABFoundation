//
//  ABMQ.h
//  ABFoundation
//
//  Created by qp on 2020/5/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ABMQSubscribeProtocol <NSObject>
- (void)onReceiveMessageFromMQ:(id)message;
@end

@interface ABMQ : NSObject
- (void)subscribe:(id<ABMQSubscribeProtocol>)obj channel:(NSString *)channel autoAck:(BOOL)autoAck;
- (void)subscribe:(id<ABMQSubscribeProtocol>)obj channels:(NSArray<NSString *> *)channels autoAck:(BOOL)autoAck;
@end

NS_ASSUME_NONNULL_END
