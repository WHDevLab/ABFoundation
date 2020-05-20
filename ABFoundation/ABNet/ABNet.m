//
//  ABNet.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABNet.h"
#import "ABNetQuene.h"
@interface ABNet ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<ABNetPluginType>> *patterns;
@property (nonatomic, strong) ABNetQuene *netQuene;
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
    if (pl == nil) {
        [self _realRequest:request];
    } else {
        ABNetRequest *req = [pl prepare:request];
        if ([pl canSend:req]) {
            [self _realRequest:req];
        }else{
            NSDictionary *obj = [pl process:req response:@{}];
            [self onSuccess:req obj:obj];
        }
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
    request.realParams = request.params;
    request.realUri = request.uri;
    [self.netQuene put:request];
}

- (void)onNetRequestSuccess:(ABNetRequest *)req obj:(NSDictionary *)obj isCache:(BOOL)isCache {
    id<ABNetPluginType> pl = [self getPL:req];
    if (pl == nil) {
        [self onSuccess:req obj:obj];
    }else{
        NSDictionary *nObj = [pl process:req response:obj];
        [self onSuccess:req obj:nObj];
    }
    
}

- (void)onNetRequestFailure:(ABNetRequest *)req err:(ABNetError *)err {
    if (req.target != nil && [req.target respondsToSelector:@selector(onNetRequestFailure:err:)]) {
        [req.target onNetRequestFailure:req err:err];
    }
}

- (void)onSuccess:(ABNetRequest *)req obj:(NSDictionary *)obj {
    if (req.target != nil && [req.target respondsToSelector:@selector(onNetRequestSuccess:obj:isCache:)]) {
        [req.target onNetRequestSuccess:req obj:obj isCache:false];
    }
}

@end
