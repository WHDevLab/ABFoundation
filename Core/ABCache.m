//
//  ABCache.m
//  ABFoundation
//
//  Created by qp on 2021/3/27.
//  Copyright © 2021 abteam. All rights reserved.
//

#import "ABCache.h"
@interface ABCache ()
@property (nonatomic, strong) NSMutableDictionary *dic;
@end
@implementation ABCache
+ (ABCache *)shared {
    static ABCache *instance = nil;
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
    }
    return self;
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


@end
