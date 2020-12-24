//
//  ABRouter.h
//  ABFoundation
//
//  Created by qp on 2020/12/18.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABRouter : NSObject
+ (void)dismiss;
+ (void)back;
+ (void)pushTo:(nullable UIViewController *)to props:(nullable NSDictionary *)props;
@end

NS_ASSUME_NONNULL_END
