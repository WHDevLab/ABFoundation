//
//  ABUtils.h
//  ABFoundation
//
//  Created by qp on 2020/7/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABTools : NSObject
+ (BOOL)isValidPhone:(NSString *)phone;
+ (BOOL)isValidEmail:(NSString *)email;

+ (NSString *)suppleZero:(NSInteger)n;
//生成二维码
+ (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size;
+ (UIImage *)getImageViewWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
