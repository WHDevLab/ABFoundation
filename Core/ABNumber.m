//
//  ABNumber.m
//  ABFoundation
//
//  Created by qp on 2020/6/22.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABNumber.h"

@implementation ABNumber
+ (double)numberFromPercentString:(NSString *)percentStr tt:(double)tt {
    
    if ([percentStr hasSuffix:@"%"]) {
        NSString *value = [percentStr stringByReplacingOccurrencesOfString:@"%" withString:@""];
        return ([value floatValue]/100)*tt;
    }
    return [percentStr floatValue];
}
@end
