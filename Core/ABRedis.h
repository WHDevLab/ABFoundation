//
//  ABRedis.h
//  ABFoundation
//
//  Created by qp on 2020/12/12.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABRedis : NSObject
+ (ABRedis *)shared;
@property (nonatomic, strong) NSString *fileName;

- (instancetype)initWithName:(NSString *)name;

- (void)set:(nullable id)value key:(NSString *)key;
- (id)get:(NSString *)key;
- (BOOL)del:(NSString *)key;

- (void)load;
- (void)save;

+ (BOOL)isLogin;
+ (void)setToken:(nullable NSString *)token;
@end

NS_ASSUME_NONNULL_END
