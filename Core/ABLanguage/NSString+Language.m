//
//  NSString+Language.m
//  ABFoundation
//
//  Created by qp on 2021/3/10.
//  Copyright © 2021 abteam. All rights reserved.
//

#import "NSString+Language.h"
#import "ABLanguage.h"
@implementation NSString (Language)
- (NSString *)localized {
    return [[ABLanguage shared] getText:self];
}
@end
