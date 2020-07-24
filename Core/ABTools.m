//
//  ABUtils.m
//  ABFoundation
//
//  Created by qp on 2020/7/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABTools.h"

@implementation ABTools
+ (BOOL)isValidPhone:(NSString *)phone
{
    NSString *regex = @"1\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phone];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
