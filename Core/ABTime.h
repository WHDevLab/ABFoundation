//
//  ABTime.h
//  Demo
//
//  Created by qp on 2020/5/11.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABTime : NSObject
+ (ABTime *)shared;
+ (NSString *)time;
+ (NSString *)timestamp;
+ (NSString *)timestampToTime:(NSString *)timestamp format:(nullable NSString *)format;
- (NSString *)howMuchTimePassed:(NSString *)timestamp;
+ (NSString *)dateToTime:(NSDate *)date format:(nullable NSString *)format;
@end

NS_ASSUME_NONNULL_END
