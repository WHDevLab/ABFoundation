//
//  ABNumber.h
//  ABFoundation
//
//  Created by qp on 2020/6/22.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABNumber : NSObject
+ (double)numberFromPercentString:(NSString *)percentStr tt:(double)tt;
@end

NS_ASSUME_NONNULL_END
