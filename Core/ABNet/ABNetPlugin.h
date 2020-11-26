//
//  ABNetPluginType.h
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#ifndef ABNetPluginType_h
#define ABNetPluginType_h
#import "ABNetRequest.h"
#import "ABNetError.h"
@protocol ABNetPluginType <NSObject>
@optional
/// Called to modify a request before sending.
- (ABNetRequest *)prepare:(ABNetRequest *)request;

/// Called immediately before a request will sent
- (BOOL)canSend:(ABNetRequest *)request;

/// Called immediately before a request is sent over the network (or stubbed).
- (void)willSend:(ABNetRequest *)request;
- (void)endSend:(ABNetRequest *)request;
- (void)willSendRequest:(ABNetRequest *)request;
- (void)completedRequest:(ABNetRequest *)request error:(nullable ABNetError *)error;
/// Called to modify a result before completion.
- (void)didReceive:(ABNetRequest *)request response:(NSDictionary *)response;

/// Called to modify a result before completion.
- (NSDictionary *)process:(ABNetRequest *)request response:(NSDictionary *)response;

- (void)didReceiveError:(ABNetRequest *)request error:(ABNetError *)error;

@end

#endif /* ABNetPluginType_h */
