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
@property (nonatomic, assign) BOOL ismute;
- (void)playBundleFileWithNames:(NSArray *)names;
- (void)playBundleFileWithMultipleName:(NSString *)multipleName;
- (void)playBundleFileWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
