//
//  NSObject+ABNet.h
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ABNet)
- (void)fetchRequest:(ABNetRequest *)request;
- (void)fetchUri:(NSString *)uri host:(NSString *)host params:(nullable NSDictionary *)params;
- (void)fetchUri:(NSString *)uri params:(nullable NSDictionary *)params;
- (void)fetchPostUri:(NSString *)uri params:(nullable NSDictionary *)params;
- (void)fetchMethod:(NSString *)method host:(nullable NSString *)host uri:(NSString *)uri params:(nullable NSDictionary *)params isCancelWhenDealloc:(BOOL)isCancelWhenDealloc cachePolicy:(ABNetRequestCachePolicy)cachePolicy cacheKey:(NSString *)cacheKey;
- (BOOL)isEmpty;
@end

NS_ASSUME_NONNULL_END
