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
        
        self.isDebugLog = true;
    }
    return self;
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
