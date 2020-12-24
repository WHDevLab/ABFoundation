//
//  ABNet.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABNet.h"
#import "ABNetQuene.h"
#import "AFNetworking.h"
#import "ABNetConfiguration.h"
#import "ABUITips.h"
#import <AFNetworking/AFNetworking.h>
@interface ABNet ()<INetData>
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<ABNetPluginType>> *patterns;
@property (nonatomic, strong) ABNetQuene *netQuene;
@property (nonatomic, assign) BOOL isReachable;
@end
@implementation ABNet
+ (ABNet *)shared {
    static ABNet *instance = nil;
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
        self.netQuene = [ABNetQuene shared];
        self.patterns = [[NSMutableDictionary alloc] init];
        self.plugins = [[NSArray alloc] init];
    }
    return self;
}

- (void)ready{
    
}

- (void)registerDataProcess:(id<ABNetPluginType>)process key:(NSString *)key {
    [self.patterns setValue:process forKey:key];
}

- (void)push:(ABNetRequest *)request {
    request.handleTarget = self;
    id<ABNetPluginType> pl = [self getPL:request];
    if (pl != nil && [pl respondsToSelector:@selector(prepare:)]) {
        ABNetRequest *req = [pl prepare:request];
        BOOL canSend = request.canSend;
        if ([pl respondsToSelector:@selector(canSend:)]) {
            canSend = [pl canSend:req];
        }
        if (canSend) {
            [self _realRequest:req];
            
            [self.plugins enumerateObjectsUsingBlock:^(id<ABNetPluginType>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj respondsToSelector:@selector(willSend:)]) {
                    [obj willSend:request];
                }
            }];
            
            [self.plugins enumerateObjectsUsingBlock:^(id<ABNetPluginType>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj respondsToSelector:@selector(completedRequest:)]) {
                    [obj willSendRequest:request];
                }
            }];
            
            if ([pl respondsToSelector:@selector(willSend:)]) {
                [pl willSend:request];
            }
        }else{
            if ([pl respondsToSelector:@selector(process:response:)]) {
                NSDictionary *obj = [pl process:req response:@{}];
                [self onSuccess:req obj:obj];
            }
        }
    } else {
        [self _realRequest:request];
        
    }
}

- (id<ABNetPluginType>)getPL:(ABNetRequest *)request {
    NSArray *keys = [self.patterns allKeys];
    for (NSString *key in keys) {
        if ([request.uri hasPrefix:key]) {
            return self.patterns[key];
        }
    }
    return nil;
}

- (void)_realRequest:(ABNetRequest *)request {
    if (request.realParams == nil) {
        request.realParams = request.params;
    }
    if (request.realUri == nil) {
        request.realUri = request.uri;
    }
    [self.netQuene put:request];

}

- (void)onNetRequestSuccess:(ABNetRequest *)req obj:(NSDictionary *)obj isCache:(BOOL)isCache {
    id<ABNetPluginType> pl = [self getPL:req];
    if (pl != nil && [pl respondsToSelector:@selector(endSend:)]) {
        [pl endSend:req];
    }
    
    [self.plugins enumerateObjectsUsingBlock:^(id<ABNetPluginType>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj endSend:req];
    }];
    
    if (pl != nil && [pl respondsToSelector:@selector(process:response:)]) {
        NSDictionary *nObj = [pl process:req response:obj];
        [self onSuccess:req obj:nObj];
    }else{
        [self onSuccess:req obj:obj];
    }
}

- (void)onNetRequestFailure:(ABNetRequest *)req err:(ABNetError *)err {
    id<ABNetPluginType> pl = [self getPL:req];
    if (self.errorHandle) {
        [self.errorHandle didReceiveError:req error:err];
    }
    
    [self.plugins enumerateObjectsUsingBlock:^(id<ABNetPluginType>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(endSend:)]) {
            [obj endSend:req];
        }
        if ([obj respondsToSelector:@selector(didReceiveError:error:)]) {
            [obj didReceiveError:req error:err];
        }
    }];
    
    [self.plugins enumerateObjectsUsingBlock:^(id<ABNetPluginType>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(completedRequest:error:)]) {
            [obj completedRequest:req error:err];
        }
    }];
    
    if (pl != nil && [pl respondsToSelector:@selector(endSend:)]) {
        [pl endSend:req];
    }
    if (pl != nil && [pl respondsToSelector:@selector(didReceiveError:error:)]) {
        [pl didReceiveError:req error:err];
    }
    
    if (req.target != nil && [req.target respondsToSelector:@selector(onNetRequestFailure:err:)]) {
        [req.target onNetRequestFailure:req err:err];
    }
}

- (void)onSuccess:(ABNetRequest *)req obj:(NSDictionary *)obj {
    if (req.target != nil && [req.target respondsToSelector:@selector(onNetRequestSuccess:obj:isCache:)]) {
        [req.target onNetRequestSuccess:req obj:obj isCache:false];
    }
}

+ (void)uploadWithURL:(NSString *)url params:(NSDictionary *)params files:(NSArray<NSDictionary<NSString *,id> *> *)fileDatas success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSDictionary *headers = [[ABNetConfiguration shared].provider headers:@"/"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/html",

                                                            @"image/jpeg",

                                                            @"image/png",

                                                            @"application/octet-stream",

                                                            @"text/json",

                                                            nil];
     [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager POST:url parameters:params headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<fileDatas.count; i++) {
            NSDictionary* unitData = fileDatas[i];
            if (unitData && [unitData objectForKey:@"key"] && [unitData objectForKey:@"filename"] && [unitData objectForKey:@"data"]) {
                if ([[unitData objectForKey:@"data"] isKindOfClass:[NSData class]]) {
                    [formData appendPartWithFileData:(NSData*)[unitData objectForKey:@"data"] name:[unitData objectForKey:@"key"] fileName:[unitData objectForKey:@"filename"] mimeType:@"application/octet-stream"];
                }else if([[unitData objectForKey:@"data"] isKindOfClass:[NSURL class]]){
                    [formData appendPartWithFileURL:(NSURL*)[unitData objectForKey:@"data"] name:[unitData objectForKey:@"key"] fileName:[unitData objectForKey:@"filename"] mimeType:@"application/octet-stream" error:nil];
                }
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld     ------ %lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
        CGFloat p = 1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        NSLog(@"%.2f", p);
    } success:success failure:failure];
}

- (BOOL)isNetReachable {
    return self.isReachable;
}

- (void)uploadObject:(ABNetUploadRequest *)request {
    
}

- (void)startNetListen:(void (^)(BOOL isReachable))block {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != AFNetworkReachabilityStatusNotReachable) {
            self.isReachable = true;
            block(true);
        }else{
            self.isReachable = false;
            block(false);
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
@end
