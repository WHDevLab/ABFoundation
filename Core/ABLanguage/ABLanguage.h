//
//  ABLanguage.h
//  ABFoundation
//
//  Created by qp on 2021/3/10.
//  Copyright © 2021 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Language.h"
NS_ASSUME_NONNULL_BEGIN

@interface ABLanguage : NSObject
@property (nonnull, strong) NSDictionary *dataMap;
+ (ABLanguage *)shared;
- (NSString *)getText:(NSString *)key;
- (void)changedLanguage;
@end

NS_ASSUME_NONNULL_END
