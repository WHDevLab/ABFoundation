//
//  ABWebSocket.m
//  ABFoundation
//
//  Created by qp on 2020/6/3.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABWebSocket.h"
#import <SocketRocket/SRWebSocket.h>
@interface ABWebSocket ()<SRWebSocketDelegate>
@property (nonatomic, strong) NSTimer *heartTimer;
@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, strong) NSString *address;
@end
@implementation ABWebSocket

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startListenAppStatus];
    }
    return self;
}

- (void)start:(NSString *)address {
    self.address = address;
    [self restart];
}

- (void)restart {
    self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:self.address]];
    self.socket.delegate = self;
    [self.socket open];
}


- (void)send:(id)message {
    id mm = message;
    for (id<ABWebSocketPluginType> pl in self.plugins) {
        mm = [pl willSendMessage:message];
    }
    
    [self.socket send:mm];
}

- (void)stop {
    if (self.socket != nil) {
        [self.socket close];
        self.socket = nil;
    }
}

#pragma mark -----------------
- (void)startHeart {
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFrequency) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.heartTimer forMode:NSRunLoopCommonModes];
}

- (void)stopHeart {
    [self.heartTimer invalidate];
    self.heartTimer = nil;
}

#pragma mark -----------------
- (void)startListenAppStatus {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationDidEnterBackground {
    NSLog(@"applicationDidEnterBackground");
    if (self.socket.readyState == SR_CONNECTING || self.socket.readyState == SR_OPEN) {
        [self.socket close];
    }
}

- (void)applicationDidBecomeActive {
    NSLog(@"applicationDidBecomeActive");
    if (self.socket != nil && (self.socket.readyState == SR_CLOSED || self.socket.readyState == SR_CLOSING)) {
        [self restart];
    }
}

- (void)stopListenAppStatus {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)timerFrequency {
    NSDictionary *dic = @{@"cmd":@"ping"};
    id mm = dic;
    for (id<ABWebSocketPluginType> pl in self.plugins) {
        mm = [pl processReceiveMessage:dic];
    }
    [self.socket sendPing:mm];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"连接成功.....");
    //心跳ping开启
    [self startHeart];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketDidConnected:)]) {
        [self.delegate webSocketDidConnected:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"收到消息了:%@",message);

    id mm = message;
    for (id<ABWebSocketPluginType> pl in self.plugins) {
        mm = [pl processReceiveMessage:message];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webSocket:didReceiveMessage:)]) {
        [self.delegate webSocket:self didReceiveMessage:mm];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"pong");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"连接失败.....");
    
    //关闭心跳ping
    [self stopHeart];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webSocket:didConnectFailWithError:)]) {
        [self.delegate webSocket:self didConnectFailWithError:error];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"连接关闭:%li",(long)code);
    NSLog(@"连接关闭:%@", reason);
    
    //关闭心跳ping
    [self stopHeart];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webSocket:didCloseWithCode:reason:)]) {
        [self.delegate webSocket:self didCloseWithCode:code reason:reason];
    }
}



- (void)dealloc
{
    [self stop];
    [self stopListenAppStatus];
}
@end
