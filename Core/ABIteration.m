//
//  ABIteration.m
//  ABFoundation
//
//  Created by qp on 2020/7/2.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABIteration.h"

@implementation ABIteration
+ (NSMutableArray *)iterationList:(NSArray *)list block:(NSMutableDictionary* (^)(NSMutableDictionary *dic, NSInteger idx))block {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<list.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:list[i]];
        NSDictionary *dd = block(dic, i);
        if (dd != nil) {
            [arr addObject:dd];
        }
    }
    return arr;
}

+ (NSDictionary *)pickKeys:(NSArray *)keys fromDictionary:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]] == false) {
        return @{};
    }
    NSArray *allkeys = dic.allKeys;
    if (allkeys.count == 0) {
        return @{};
    }
    
    NSMutableDictionary *_tmpDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in allkeys) {
        if (key == nil || [key isKindOfClass:[NSNull class]]) {
            continue;
        }
        if ([keys containsObject:key]) {
            [_tmpDic setValue:dic[key] forKey:key];
        }
    }
    return _tmpDic;
}

+ (NSDictionary *)excludeKeys:(NSArray *)keys fromDictionary:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]] == false) {
        return @{};
    }
    NSArray *allkeys = dic.allKeys;
    if (allkeys.count == 0) {
        return @{};
    }
    
    NSMutableDictionary *_tmpDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in allkeys) {
        if (key == nil || [key isKindOfClass:[NSNull class]]) {
            continue;
        }
        if ([keys containsObject:key] == false) {
            [_tmpDic setValue:dic[key] forKey:key];
        }
    }
    return _tmpDic;
}

+ (NSDictionary *)pickKeysAndReplaceWithMapping:(NSDictionary *)mapping fromDictionary:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]] || ![mapping isKindOfClass:[NSDictionary class]] ) {
        return @{};
    }
    NSArray *allkeys = dic.allKeys;
    if (allkeys.count == 0) {
        return @{};
    }
    
    NSMutableDictionary *_tmpDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in allkeys) {
        if (key == nil || [key isKindOfClass:[NSNull class]]) {
            continue;
        }
        if ([mapping.allKeys containsObject:key]) {
            if (dic[key] != nil && mapping[key] != nil) {
                [_tmpDic setValue:dic[key] forKey:mapping[key]];
            }
        }
    }
    return _tmpDic;
}

+ (NSArray *)filter:(NSArray *)list block:(nonnull BOOL (^)(NSMutableDictionary * _Nonnull))block {
    NSMutableArray *newList = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *item in list) {
        if (block(item)) {
            [newList addObject:item];
        }
    }
    
    return newList;
}

+ (NSDictionary *)setAndReaplceKeyTo:(NSDictionary *)tdic with:(NSDictionary *)wdic {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:tdic];
    NSArray *allKeys = [wdic allKeys];
    for (NSString *key in allKeys) {
        dic[key] = wdic[key];
    }
    return dic;
}

@end
