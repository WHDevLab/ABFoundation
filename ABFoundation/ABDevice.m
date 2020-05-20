//
//  ABDevice.m
//  Demo
//
//  Created by qp on 2020/5/11.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABDevice.h"
#import <UIKit/UIKit.h>
@implementation ABDevice
- (NSString *)appVersion {
    return [UIDevice currentDevice].systemVersion;
}
@end
