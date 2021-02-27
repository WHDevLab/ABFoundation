//
//  ABNetError.h
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN
@class ABNetRequest;
@interface ABNetError : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *uri;

@property (nonatomic, strong) NSString *des;

- (ABNetError *)initWithError:(NSError *)error;
- (ABNetError *)initWithDic:(NSDictionary *)dic;
- (BOOL)isNetReachable;
- (NSString *)desf:(ABNetRequest *)request error:(ABNetError *)error;
@end

NS_ASSUME_NONNULL_END
