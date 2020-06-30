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

- (NSString *)deviceTokenStringFromData:(NSData *)deviceToken {
    if (@available(iOS 13.0, *)) {
        NSMutableString *deviceTokenString = [NSMutableString string];
        const char *bytes = deviceToken.bytes;
        NSInteger count = deviceToken.length;
        for (int i = 0; i < count; i++) {
            [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
        }
        return deviceTokenString;
    }
    NSString *deviceTokenStr =  [[[[deviceToken description]
                                       stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                      stringByReplacingOccurrencesOfString:@">" withString:@""]
                                     stringByReplacingOccurrencesOfString:@" " withString:@""];
    return deviceTokenStr;
}
@end
