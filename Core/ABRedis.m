//
//  ABRedis.m
//  ABFoundation
//
//  Created by qp on 2020/12/12.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABRedis.h"
@interface ABRedis()
@property (nonatomic, strong) NSMutableDictionary *dic;
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
        self.fileName = @"data";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self save];
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
    [self.dic setValue:value forKey:key];
}

- (id)get:(NSString *)key {
    return [self.dic objectForKey:key];
}

- (BOOL)del:(NSString *)key {
    [self.dic removeObjectForKey:key];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
