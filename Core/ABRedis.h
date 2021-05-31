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
/// 将键 key 的值设置为 value
- (void)set:(nullable NSString *)value key:(NSString *)key;
/// 只在键 key 不存在的情况下， 将键 key 的值设置为 value
- (void)setnx:(nullable NSString *)value key:(NSString *)key;
/// 将键 key 的值设置为 value ， 并将键 key 的生存时间设置为 seconds 秒钟。
- (void)setex:(nullable NSString *)value key:(NSString *)key seconds:(int)seconds;
/// 将键 key 的值设为 value ， 并返回键 key 在被设置之前的旧值
- (NSString *)getset:(nullable NSString *)value key:(NSString *)key;
/// 返回与键 key 相关联的字符串值
- (NSString *)get:(NSString *)key;
/// 返回键 key 储存的字符串值的长度
- (NSInteger)strlen:(NSString *)key;

/// 如果键 key 已经存在并且它的值是一个字符串， APPEND 命令将把 value 追加到键 key 现有值的末尾。
/// 如果 key 不存在， APPEND 就简单地将键 key 的值设为 value ， 就像执行 SET key value 一样。
- (int)append:(nullable NSString *)value key:(NSString *)key;
- (BOOL)del:(NSString *)key;

- (void)load;
- (void)save;

+ (BOOL)isLogin;
+ (void)setToken:(nullable NSString *)token;
+ (NSDictionary *)auth;
@end

NS_ASSUME_NONNULL_END
