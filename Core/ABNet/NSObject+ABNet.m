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
#import "ABNetUploadRequest.h"
#import "NSString+AB.h"
@implementation NSObject (ABNet)
- (void)fetchRequest:(ABNetRequest *)request {
    [request ready];
    [[ABNet shared] push:request];
}

- (void)fetchUri:(NSString *)uri host:(NSString *)host params:(nullable NSDictionary *)params {
    [self fetchMethod:@"get" host:host uri:uri params:params isCancelWhenDealloc:true cachePolicy:ABNetRequestCachePolicyNone cacheKey:@"xx"];
}

- (void)fetchUri:(NSString *)uri params:(nullable NSDictionary *)params {
    [self fetchMethod:@"get" host:nil uri:uri params:params isCancelWhenDealloc:true cachePolicy:ABNetRequestCachePolicyNone cacheKey:@"xx"];
}

- (void)fetchPostUri:(NSString *)uri params:(nullable NSDictionary *)params {
    [self fetchMethod:@"post" host:nil uri:uri params:params isCancelWhenDealloc:true cachePolicy:ABNetRequestCachePolicyNone cacheKey:@"xx"];
}

- (void)fetchPostUri:(NSString *)uri params:(nullable NSDictionary *)params cachePolicy:(ABNetRequestCachePolicy)cachePolicy {
    [self fetchMethod:@"post" host:nil uri:uri params:params isCancelWhenDealloc:true cachePolicy:cachePolicy cacheKey:[uri md5]];
}

- (void)fetchMethod:(NSString *)method host:(nullable NSString *)host uri:(NSString *)uri params:(nullable NSDictionary *)params isCancelWhenDealloc:(BOOL)isCancelWhenDealloc cachePolicy:(ABNetRequestCachePolicy)cachePolicy cacheKey:(NSString *)cacheKey {
    
    ABNetRequest *request = [[ABNetRequest alloc] init];
    if ([uri hasPrefix:@"http"]) {
        NSURL *uu = [NSURL URLWithString:uri];
        if (uu.port == nil) {
            request.host = [NSString stringWithFormat:@"%@://%@", uu.scheme,uu.host];
        }else{
            request.host = [NSString stringWithFormat:@"%@://%@:%@", uu.scheme,uu.host, uu.port];
        }
        request.uri = [NSURL URLWithString:uri].path;
        request.putUrl = uri;
    }else {
        if (host == nil) {
            request.host = [[ABNetConfiguration shared].provider host:uri];
        }else{
            request.host = host;
        }
        request.uri = uri;
    }
    request.headers = [[ABNetConfiguration shared].provider headers:uri];
    
    request.params = params;
    request.method = method;

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

- (void)uploadToUri:(NSString *)uri params:(NSDictionary *)params data:(UIImage *)data key:(NSString *)key {
    if (data == nil) {
        NSLog(@"data is empty");
        return;
    }
    ABNetRequest *request = [[ABNetRequest alloc] init];
    if ([uri hasPrefix:@"http"]) {
        NSURL *uu = [NSURL URLWithString:uri];
        if (uu.port == nil) {
            request.host = [NSString stringWithFormat:@"%@://%@", uu.scheme,uu.host];
        }else{
            request.host = [NSString stringWithFormat:@"%@://%@:%@", uu.scheme,uu.host, uu.port];
        }
        request.uri = [NSURL URLWithString:uri].path;
        request.putUrl = uri;
    }else {
        request.host = [[ABNetConfiguration shared].provider host:uri];
        request.uri = uri;
    }
    request.headers = [[ABNetConfiguration shared].provider headers:uri];
    
    request.params = params;
    request.method = @"upload";
    
    request.binarys = @[UIImageJPEGRepresentation(data, 0.2)];
    request.binaryKey = key;

    request.target = (id<INetData>)self;
    request.isCancelWhenTargetDealloc = false;
    
    [request ready];
    [[ABNet shared] push:request];
}

- (void)uploadRequest:(ABNetUploadRequest *)request {
    [[ABNet shared] pushUpload:request];
}

- (BOOL)isEmpty {
    if (self == nil || [self isKindOfClass:[NSNull class]]) {
        return true;
    }
    return false;
}
@end
