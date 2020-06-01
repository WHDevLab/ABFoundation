//
//  ABNetError.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABNetError.h"
#import "ABNetConfiguration.h"
@implementation ABNetError
- (ABNetError *)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        self.code = error.code;
        self.message = @"服务器开小差了";
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
    return [NSString stringWithFormat:@"code:%li;reason:%@", (long)self.code,self.message];
}

@end
