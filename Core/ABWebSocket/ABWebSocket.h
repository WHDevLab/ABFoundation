//
//  ABWebSocket.h
//  ABFoundation
//
//  Created by qp on 2020/6/3.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class ABWebSocket;

@protocol ABWebSocketPluginType <NSObject>
- (id)processReceiveMessage:(id)message;
- (id)willSendMessage:(id)message;
@end

@protocol ABWebSocketProtocol <NSObject>

- (void)webSocketDidConnected:(ABWebSocket *)socket;
- (void)webSocket:(ABWebSocket *)socket didReceiveMessage:(id)message;
- (void)webSocket:(ABWebSocket *)socket didConnectFailWithError:(nullable NSError *)error;
- (void)webSocket:(ABWebSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason;
@end



@interface ABWebSocket : NSObject
- (void)start:(NSString *)address;
- (void)send:(id)message;
- (void)stop;

@property (nonatomic, weak) id<ABWebSocketProtocol> delegate;
@property (nonatomic, strong) NSArray<ABWebSocketPluginType>* plugins;

@end

NS_ASSUME_NONNULL_END
