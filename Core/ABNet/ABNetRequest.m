//
//  ABNetRequest.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABNetRequest.h"
#import <CommonCrypto/CommonCrypto.h>

@interface ABNetRequest ()
@property (nonatomic, assign) NSTimeInterval creatTime;
@end
@implementation ABNetRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = @"get";
        self.timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        self.creatTime = [[NSDate date] timeIntervalSince1970];
        self.status = ABNetRequestStatusNormal;
        self.isShowLoading = true;
        self.canSend = true;
    }
    return self;
}

- (void)ready {
    self.identifier = [self md5:self.uri];
}

- (NSString *)md5:(NSString *)str
{
    const char *data = [str UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(data, (CC_LONG)strlen(data), result);
    NSMutableString *mString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        //02:不足两位前面补0,   %02x:十六进制数
        [mString appendFormat:@"%02x",result[i]];
    }
    
    return mString;
}

- (BOOL)isExpire {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now-self.creatTime > 60) {
        return true;
    }
    return false;
}
@end
