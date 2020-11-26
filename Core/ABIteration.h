//
//  ABIteration.h
//  ABFoundation
//
//  Created by qp on 2020/7/2.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABIteration : NSObject
+ (NSMutableArray *)iterationList:(NSArray *)list block:(NSMutableDictionary* (^)(NSMutableDictionary *dic, NSInteger idx))block;

+ (NSDictionary *)pickKeys:(NSArray *)keys fromDictionary:(NSDictionary *)dic;
// mapping -> {"orginKey":"newKey"} 原始key 映射到新的key
+ (NSDictionary *)pickKeysAndReplaceWithMapping:(NSDictionary *)mapping fromDictionary:(NSDictionary *)dic;
+ (NSDictionary *)excludeKeys:(NSArray *)keys fromDictionary:(NSDictionary *)dic;

+ (NSArray *)filter:(NSArray *)list block:(BOOL (^)(NSMutableDictionary *dic))block;
+ (NSDictionary *)setAndReaplceKeyTo:(NSDictionary *)tdic with:(NSDictionary *)wdic;
@end

NS_ASSUME_NONNULL_END
