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
//将键 key 的值设置为 value
- (void)set:(nullable id)value key:(NSString *)key;
//只在键 key 不存在的情况下， 将键 key 的值设置为 value 
- (void)setnx:(nullable id)value key:(NSString *)key;
//将键 key 的值设置为 value ， 并将键 key 的生存时间设置为 seconds 秒钟。
- (void)setex:(nullable id)value key:(NSString *)key seconds:(int)seconds;
- (id)get:(NSString *)key;
- (BOOL)del:(NSString *)key;

- (void)load;
- (void)save;

+ (BOOL)isLogin;
+ (void)setToken:(nullable NSString *)token;
@end

NS_ASSUME_NONNULL_END
