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
#import "ABTime.h"
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
    return [NSString stringWithFormat:@"%@(%@)(%li)", self.message?self.message:@"服务器开小差了", self.uri, (long)self.code];
//    return [NSString stringWithFormat:@"code:%li;reason:%@", (long)self.code,self.message];
}


- (NSString *)desf:(ABNetRequest *)request error:(ABNetError *)error {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"\n\n******************请求发生错误************************\n"];
    [string appendString:[NSString stringWithFormat:@"**CurrentTime:%@\n", [ABTime timestamp]]];
    [string appendString:[NSString stringWithFormat:@"**CurrentTimeFormat:%@\n", [ABTime timestampToTime:[ABTime timestamp] format:@"yyyy-MM-dd hh:mm:ss"]]];
    [string appendString:[NSString stringWithFormat:@"**CreateTimeFormat:%@\n", [ABTime timestampToTime:request.timestamp format:@"yyyy-MM-dd hh:mm:ss"]]];
    [string appendString:[NSString stringWithFormat:@"**CreateTime:%@\n", request.timestamp]];
    [string appendString:[NSString stringWithFormat:@"**CreateTimeFormat:%@\n", [ABTime timestampToTime:request.timestamp format:@"yyyy-MM-dd hh:mm:ss"]]];
    [string appendString:[NSString stringWithFormat:@"**From:%@\n", [request.target description]]];
    [string appendString:[NSString stringWithFormat:@"**Host:%@\n", request.host]];
    [string appendString:[NSString stringWithFormat:@"**Api:%@\n", request.uri]];
    [string appendString:[NSString stringWithFormat:@"**RealApi:%@\n", request.realUri]];
    [string appendString:[NSString stringWithFormat:@"**Method:%@\n", request.method]];
    [string appendString:[NSString stringWithFormat:@"**Headers:%@\n", request.headers]];
    [string appendString:[NSString stringWithFormat:@"**Params:%@\n", request.params]];
    [string appendString:[NSString stringWithFormat:@"**RealParams:%@\n", request.realParams]];
    [string appendString:[NSString stringWithFormat:@"**Reason:%@\n", error.message]];
    [string appendString:[NSString stringWithFormat:@"**ReasonCode:%li\n", (long)error.code]];
//        [string appendString:[NSString stringWithFormat:@"**ReasonObject:%@\n", responseObject]];
    [string appendString:@"****************************************************\n\n"];
    
    return string;
}

- (BOOL)isNetReachable {
    return [AFNetworkReachabilityManager manager].reachable;
}

@end
