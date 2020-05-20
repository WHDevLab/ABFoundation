//
//  ABNetConfiguration.h
//  ABFoundation
//
//  Created by qp on 2020/5/20.
//  Copyright © 2020 abteam. All rights reserved.
//  alone supper json

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABNetConfigurationProvider : NSObject
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, assign) NSInteger successCode;
@property (nonatomic, strong) NSString *codeKey;
@property (nonatomic, strong) NSString *msgKey;
@property (nonatomic, strong) NSString *dataKey;
@property (nonatomic, assign) BOOL isDebugLog;
@end

@interface ABNetConfiguration : NSObject
+ (ABNetConfiguration *)shared;
@property (nonatomic, strong) ABNetConfigurationProvider *provider;
@end

NS_ASSUME_NONNULL_END
