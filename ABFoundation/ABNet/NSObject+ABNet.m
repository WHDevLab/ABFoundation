//
//  NSObject+ABNet.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "NSObject+ABNet.h"
#import "ABNet.h"
@implementation NSObject (ABNet)
- (void)fetchUri:(NSString *)uri params:(NSDictionary *)params {
    [self fetchMethod:@"get" uri:uri params:params isCancelWhenDealloc:true cachePolicy:ABNetRequestCachePolicyNone cacheKey:@"xx"];
}

- (void)fetchPostUri:(NSString *)uri params:(NSDictionary *)params {
    [self fetchMethod:@"post" uri:uri params:params isCancelWhenDealloc:true cachePolicy:ABNetRequestCachePolicyNone cacheKey:@"xx"];
}

- (void)fetchMethod:(NSString *)method uri:(NSString *)uri params:(NSDictionary *)params isCancelWhenDealloc:(BOOL)isCancelWhenDealloc cachePolicy:(ABNetRequestCachePolicy)cachePolicy cacheKey:(NSString *)cacheKey {
    
//    NSDictionary *userInfo = [[Service shared] userInfo];
    ABNetRequest *request = [[ABNetRequest alloc] init];
//    request.headers = @{
//        @"token":userInfo[@"token"],
//        @"userid":[NSString stringWithFormat:@"%@", userInfo[@"user_id"]]
//    };
//    request.host = HTTPHost;
    request.params = params;
    request.method = method;
    request.uri = uri;
    request.target = (id<INetData>)self;
    request.isCancelWhenTargetDealloc = isCancelWhenDealloc;
    [request ready];
    [[ABNet shared] push:request];
}
@end
