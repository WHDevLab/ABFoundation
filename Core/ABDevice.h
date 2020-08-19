//
//  ABDevice.h
//  Demo
//
//  Created by qp on 2020/5/11.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABDevice : NSObject
- (NSString *)appVersion;
- (NSString *)deviceTokenStringFromData:(NSData *)data;
+ (BOOL)isNotchScreen;

+ (BOOL)isAvailableCamera; //相机权限
+ (BOOL)isAvailableRecord; //麦克风权限(调用会弹出授权框)
+ (BOOL)isAvailablePhoto; //相册权限
+ (BOOL)isAvailableNet; //联网权限

+ (void)gotoAppSetting;

+ (CGFloat)pixelWidth:(CGFloat)w;

+ (CGFloat)safeHeight;


@end

NS_ASSUME_NONNULL_END
