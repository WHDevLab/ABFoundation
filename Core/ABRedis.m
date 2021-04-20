//
//  ABRedis.m
//  ABFoundation
//
//  Created by qp on 2020/12/12.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABRedis.h"

#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_dic) return nil; \
_lock = dispatch_semaphore_create(1); \
return self;


#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@interface ABRedis()
{
    dispatch_queue_t _queue;
}
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableDictionary *expires;
@end
@implementation ABRedis
+ (ABRedis *)shared {
    static ABRedis *instance = nil;
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
        self.dic = [[NSMutableDictionary alloc] init];
        self.expires = [[NSMutableDictionary alloc] init];
        self.fileName = @"data";
        _queue = dispatch_queue_create("abredis", DISPATCH_QUEUE_CONCURRENT);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self save];
    [self activeExpireCycle];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.dic = [[NSMutableDictionary alloc] init];
        self.fileName = name;
    }
    return self;
}

- (void)load {
    NSString *filePath = [self _filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        self.dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
}

- (NSString *)_filePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath, self.fileName];
    return filePath;
}

- (void)save {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dic options:NSJSONWritingPrettyPrinted error:nil];
    if ([data writeToFile:[self _filePath] atomically:true]) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
}

- (void)set:(nullable id)value key:(NSString *)key {
    dispatch_barrier_async(_queue, ^{
        [self.dic setValue:value forKey:key];
    });
}

- (void)setnx:(NSString *)value key:(NSString *)key {
    if (self.dic[key] == nil) {
        [self set:value key:key];
    }
}

- (void)setex:(NSString *)value key:(NSString *)key seconds:(int)seconds {
    [self set:value key:key];
    [self setExpire:key when:seconds];
}

- (NSString *)getset:(NSString *)value key:(NSString *)key {
    id vv = [self get:key];
    [self set:value key:key];
    return vv;
}

- (NSString *)get:(NSString *)key {
    __block id o;
    dispatch_sync(_queue, ^{
        if (![self expireIfNeeded:key]) {
            o = [self.dic objectForKey:key];
        }
    });
    return o;
}

- (BOOL)del:(NSString *)key {
    dispatch_barrier_async(_queue, ^{
        [self.dic removeObjectForKey:key];
    });
    return true;
}

+ (BOOL)isLogin {
    NSString *token = [[ABRedis shared] get:@"token"];
    return token != nil;
}

+ (void)setToken:(nullable NSString *)token {
    if (token == nil) {
        [[ABRedis shared] del:@"token"];
    }else{
        [[ABRedis shared] set:token key:@"token"];
    }
    
}

#pragma mark ----------- own -----------

- (BOOL)expireIfNeeded:(NSString *)key {
    if ([self keyIsExpired:key]) {
        [self propagateExpire:key];
        [self syncDelete:key];
        return true;
    }
    return false;
}

- (BOOL)keyIsExpired:(NSString *)key {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval record = [self getExpire:key];
    return [self getExpire:key];
}

- (void)setExpire:(NSString *)key when:(int)seconds {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    self.expires[key] = @(now+seconds);
}

- (NSTimeInterval)getExpire:(NSString *)key {
    return [self.expires[key] timeInterval];
}

- (void)propagateExpire:(NSString *)key {
    
}

- (void)syncDelete:(NSString *)key {
    [self.expires removeObjectForKey:key];
}

//timer delete expire keys
- (void)activeExpireCycle {
    NSArray *keys = [self.expires allKeys];
    for (NSString *key in keys) {
        [self expireIfNeeded:key];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
