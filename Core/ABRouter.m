//
//  ABRouter.m
//  ABFoundation
//
//  Created by qp on 2020/12/18.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABRouter.h"
#import "UIApplication+AB.h"
#import "UIViewController+AB.h"
@implementation ABRouter
+ (void)dismiss {
    [[[UIApplication sharedApplication] topViewController] dismissViewControllerAnimated:true completion:nil];
}

+ (void)back {
    [[[UIApplication sharedApplication] topViewController].navigationController popViewControllerAnimated:true];
}

+ (void)pushTo:(nullable UIViewController *)to props:(nullable NSDictionary *)props {
    to.props = props;
    UIViewController *from = [[UIApplication sharedApplication] topViewController];
    if (from.navigationController != nil) {
        [from.navigationController pushViewController:to animated:true];
    }
    else if (from.parent.navigationController != nil) {
        [from.parent.navigationController pushViewController:to animated:true];
    }
}

@end
