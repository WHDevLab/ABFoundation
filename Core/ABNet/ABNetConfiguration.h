//
//  ABNetConfiguration.h
//  ABFoundation
//
//  Created by qp on 2020/5/20.
//  Copyright © 2020 abteam. All rights reserved.
//  alone supper json

#import <Foundation/Foundation.h>
#import "ABNetRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface ABNetConfigurationProvider : NSObject
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, assign) NSInteger successCode;
@property (nonatomic, strong) NSString *codeKey;
@property (nonatomic, strong) NSString *msgKey;
@property (nonatomic, strong) NSString *dataKey;
@property (nonatomic, assign) BOOL isDebugLog;
@property (nonatomic, assign) CGFloat timeoutInterval;

- (NSString *)host:(NSString *)uri;
- (NSDictionary *)headers:(NSString *)uri;
- (NSString *)contentType:(NSString *)uri;
- (NSInteger)successCode:(ABNetRequest *)request;
- (NSString *)codeKey:(ABNetRequest *)request;
- (NSString *)msgKey:(ABNetRequest *)request;
- (NSString *)dataKey:(ABNetRequest *)request;

@end

@interface ABNetConfiguration : NSObject
+ (ABNetConfiguration *)shared;
@property (nonatomic, strong) ABNetConfigurationProvider *provider;
@end

NS_ASSUME_NONNULL_END
