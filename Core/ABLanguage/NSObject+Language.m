//
//  NSObject+Language.m
//  ABFoundation
//
//  Created by qp on 2021/3/10.
//  Copyright © 2021 abteam. All rights reserved.
//

#import "NSObject+Language.h"
#import <objc/runtime.h>
#import "NSString+Language.h"
@implementation NSObject (Language)
- (void)listenLanguageChanged {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(language_didChanged) name:@"ABLanguageChangedNotification" object:nil];
    [self language_didChanged];
}

- (void)language_didChanged {
    if (self.langKey == nil) {
        return;
    }
    if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)self;
        for (UIViewController *vc in tab.childViewControllers) {
            vc.tabBarItem.title = @"123";
        }
    }
    if ([self isKindOfClass:[UITabBarItem class]]) {
        [(UITabBarItem *)self setTitle:[self.langKey localized]];
    }
    if ([self isKindOfClass:[UIButton class]]) {
        [(UIButton *)self setTitle:[self.langKey localized] forState:UIControlStateNormal];
    }
}

- (NSString *)langKey {
    return objc_getAssociatedObject(self, @"langKey");
}

- (void)setLangKey:(NSString *)langKey {
    if (langKey == nil) {
        return;
    }
    objc_setAssociatedObject(self, @"langKey", langKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self listenLanguageChanged];
}

@end
