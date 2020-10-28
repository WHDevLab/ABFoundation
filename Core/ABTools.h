//
//  ABUtils.h
//  ABFoundation
//
//  Created by qp on 2020/7/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ABTools : NSObject
+ (BOOL)isValidPhone:(NSString *)phone;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)isValidCarNo:(NSString*)carno;
+ (BOOL)isValidIdentityCardNo:(NSString *)cardno;
+ (BOOL)isValidBankCardNo:(NSString *)cardNo;
+ (BOOL)isValidPassword:(NSString *)password;

+ (NSString *)suppleZero:(NSInteger)n;
//生成二维码
+ (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size;
+ (UIImage *)getImageViewWithView:(UIView *)view;
+ (NSString *)returnBankCard:(NSString *)BankCardStr;

+ (NSString *)convertNumberToKW:(NSInteger)kw;
+ (NSInteger)compareVersion2:(NSString *)v1 to:(NSString *)v2;
@end

NS_ASSUME_NONNULL_END
