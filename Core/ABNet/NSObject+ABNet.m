//
//  NSObject+ABNet.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "NSObject+ABNet.h"
#import "ABNetConfiguration.h"
#import "ABNet.h"
@implementation NSObject (ABNet)

- (void)fetchUri:(NSString *)uri host:(NSString *)host params:(nullable NSDictionary *)params {
    [self fetchMethod:@"get" host:host uri:uri params:params isCancelWhenDealloc:true cachePolicy:ABNetRequestCachePolicyNone cacheKey:@"xx"];
}

- (void)fetchUri:(NSString *)uri params:(nullable NSDictionary *)params {
    [self fetchMethod:@"get" host:nil uri:uri params:params isCancelWhenDealloc:true cachePolicy:ABNetRequestCachePolicyNone cacheKey:@"xx"];
}

- (void)fetchPostUri:(NSString *)uri params:(nullable NSDictionary *)params {
    [self fetchMethod:@"post" host:nil uri:uri params:params isCancelWhenDealloc:true cachePolicy:ABNetRequestCachePolicyNone cacheKey:@"xx"];
}

- (void)fetchMethod:(NSString *)method host:(nullable NSString *)host uri:(NSString *)uri params:(nullable NSDictionary *)params isCancelWhenDealloc:(BOOL)isCancelWhenDealloc cachePolicy:(ABNetRequestCachePolicy)cachePolicy cacheKey:(NSString *)cacheKey {
    
    ABNetRequest *request = [[ABNetRequest alloc] init];
    request.headers = [[ABNetConfiguration shared].provider headers:uri];
    if (host == nil) {
        request.host = [[ABNetConfiguration shared].provider host:uri];
    }else{
        request.host = host;
    }
    request.params = params;
    request.method = method;
    request.uri = uri;
    request.target = (id<INetData>)self;
    request.isCancelWhenTargetDealloc = isCancelWhenDealloc;
    
    if ([uri hasPrefix:@"http://"] || [uri hasPrefix:@"https://"]) {
        NSURL *url = [NSURL URLWithString:uri];
        request.host = [NSString stringWithFormat:@"%@://%@:%@", url.scheme, url.host, url.port];
        request.uri = url.path;
    }
    
    [request ready];
    [[ABNet shared] push:request];
}
@end
