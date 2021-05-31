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
#import "ABUINavigationController.h"
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

+ (void)gotoWeb:(NSString *)path {
    UIViewController *vc = [[NSClassFromString(@"ABUIWebViewController") alloc] init];
    [ABRouter pushTo:vc props:@{@"path":path}];
}

+ (void)gotoPageWithClassString:(NSString *)string data:(nullable NSDictionary *)data {
    UIViewController *vc = [[NSClassFromString(string) alloc] init];
    vc.title = data[@"title"];
    [ABRouter pushTo:vc props:data];
}

+ (void)doLogin {
    UIViewController *topVC = [[UIApplication sharedApplication] topViewController];
    if ([[[topVC class] description] isEqualToString:@"LoginViewController"]) {
        return;
    }
    UIViewController *vc = (UIViewController *)NSClassFromString(@"LoginViewController");
    ABUINavigationController *nav = [[ABUINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [nav setNavigationBarHidden:true];
    [topVC presentViewController:nav animated:true completion:nil];
}

@end
