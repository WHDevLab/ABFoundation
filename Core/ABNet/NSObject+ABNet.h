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
- (void)fetchUri:(NSString *)uri params:(NSDictionary *)params;
- (void)fetchPostUri:(NSString *)uri params:(NSDictionary *)params;
- (void)fetchMethod:(NSString *)method uri:(NSString *)uri params:(NSDictionary *)params isCancelWhenDealloc:(BOOL)isCancelWhenDealloc cachePolicy:(ABNetRequestCachePolicy)cachePolicy cacheKey:(NSString *)cacheKey;
@end

NS_ASSUME_NONNULL_END
