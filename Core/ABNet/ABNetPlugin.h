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
@protocol ABNetPluginType <NSObject>
/// Called to modify a request before sending.
- (ABNetRequest *)prepare:(ABNetRequest *)request;

/// Called immediately before a request will sent
- (BOOL)canSend:(ABNetRequest *)request;

/// Called immediately before a request is sent over the network (or stubbed).
- (void)willSend:(ABNetRequest *)request;

/// Called to modify a result before completion.
- (void)didReceive:(ABNetRequest *)request response:(NSDictionary *)response;

/// Called to modify a result before completion.
- (NSDictionary *)process:(ABNetRequest *)request response:(NSDictionary *)response;
@end

#endif /* ABNetPluginType_h */
