//
//  ABAudio.h
//  ABFoundation
//
//  Created by qp on 2020/7/2.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABAudio : NSObject
+ (ABAudio *)shared;
- (void)playBundleFileWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
