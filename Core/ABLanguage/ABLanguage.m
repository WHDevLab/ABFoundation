//
//  ABLanguage.m
//  ABFoundation
//
//  Created by qp on 2021/3/10.
//  Copyright © 2021 abteam. All rights reserved.
//

#import "ABLanguage.h"
#import "ABRedis.h"
NSString * const ABLanguageChangedNotification = @"ABLanguageChangedNotification";
@implementation ABLanguage
+ (ABLanguage *)shared {
    static ABLanguage *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)getText:(NSString *)key {
    NSString *lang = [[ABRedis shared] get:@"lang"];
    NSString *r = self.dataMap[key][lang];
    if (r == nil) {
        return @"x";
    }
    return r;
}

- (void)changedLanguage {
    [[NSNotificationCenter defaultCenter] postNotificationName:ABLanguageChangedNotification object:nil];
}

@end
