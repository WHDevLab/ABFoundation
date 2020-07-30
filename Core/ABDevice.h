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

+ (BOOL)isAvailableCamera;

+ (void)gotoAppSetting;

+ (CGFloat)pixelWidth:(CGFloat)w;

@end

NS_ASSUME_NONNULL_END
