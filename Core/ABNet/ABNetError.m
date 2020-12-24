//
//  ABNetError.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABNetError.h"
#import "ABNetConfiguration.h"
#import "ABNet.h"
@implementation ABNetError
- (ABNetError *)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        NSLog(@"%@", error);
        self.code = error.code;
        if ([[ABNet shared] isNetReachable]) {
            self.message = @"服务器开小差了";
        }else{
            self.message = @"网络不可用，请检查网络";
        }
    }
    return self;
}

- (ABNetError *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        self.code = [dic[[ABNetConfiguration shared].provider.codeKey] intValue];
        self.message = dic[[ABNetConfiguration shared].provider.msgKey];
    }
    return self;
}

- (NSString *)des
{
    return [NSString stringWithFormat:@"%@(%li)", self.message?self.message:@"服务器开小差了", (long)self.code];
//    return [NSString stringWithFormat:@"code:%li;reason:%@", (long)self.code,self.message];
}

- (BOOL)isNetReachable {
    return [AFNetworkReachabilityManager manager].reachable;
}

@end
