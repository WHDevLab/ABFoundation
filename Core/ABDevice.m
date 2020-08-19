//
//  ABDevice.m
//  Demo
//
//  Created by qp on 2020/5/11.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABDevice.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "ABDefines.h"
@import CoreTelephony;
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

+ (BOOL)isNotchScreen {

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }

    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;

    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }

    return NO;
}

+ (BOOL)isAvailableCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        // 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            return false;
        }else{
            return true;
        }
    }
    return false;
}

+ (BOOL)isAvailableRecord{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {// 未询问用户是否授权
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {//用户选择允许
                    return true;
                } else {//用户选择不允许
                    return false;
                }
            }];
        }
    } else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
        return false;
    } else{
        return true;
    }
    return false;
}

+ (BOOL)isAvailablePhoto {
    return true;
//    __weak __typeof(self)weakSelf = self;
//    PHAuthorizationStatus ss = PHAuthorizationStatusAuthorized;
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//        ss = status;
//    }];
//
//    return status == PHAuthorizationStatusAuthorized;
}

+ (BOOL)isAvailableNet {
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestricted) {
        return true;
    }
    return false;
}

+ (void)gotoAppSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (CGFloat)pixelWidth:(CGFloat)w {
    return ([UIScreen mainScreen].bounds.size.width/375.0)*w;
}

+ (CGFloat)safeHeight {
    if (IS_iPhoneX) {
        return 34;
    }
    return 0;
}
@end
