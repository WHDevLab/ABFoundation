//
//  ABNetConfiguration.m
//  ABFoundation
//
//  Created by qp on 2020/5/20.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABNetConfiguration.h"
@implementation ABNetConfigurationProvider
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.codeKey = @"code";
        self.msgKey = @"msg";
        self.dataKey = @"data";
        self.headers = @{};
        self.successCode = 200;
        self.contentType = @"application/json";
        
        self.isDebugLog = true;
        self.timeoutInterval = 5.f;
    }
    return self;
}

- (NSString *)host:(NSString *)uri {
    return self.host;
}

- (NSDictionary *)headers:(NSString *)uri {
    return self.headers;
}

- (NSInteger)successCode:(ABNetRequest *)request {
    return self.successCode;
}

- (NSString *)dataKey:(ABNetRequest *)request {
    return self.dataKey;
}

- (NSString *)msgKey:(ABNetRequest *)request {
    return self.msgKey;
}

- (NSString *)contentType:(NSString *)request {
    return self.contentType;
}

- (NSString *)codeKey:(ABNetRequest *)request {
    return self.codeKey;
}

- (BOOL)isTCPRequest:(ABNetRequest *)request {
    return false;
}

@end

@implementation ABNetConfiguration
+ (ABNetConfiguration *)shared {
    static ABNetConfiguration *instance = nil;
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
        self.provider = [[ABNetConfigurationProvider alloc] init];
    }
    return self;
}

@end
