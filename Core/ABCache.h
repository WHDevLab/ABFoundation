//
//  ABCache.h
//  ABFoundation
//
//  Created by qp on 2021/3/27.
//  Copyright © 2021 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCache : NSObject
+ (ABCache *)shared;
- (void)set:(nullable id)value key:(NSString *)key;
- (id)get:(NSString *)key;
- (BOOL)del:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
