//
//  ABNetUploadRequest.m
//  ABFoundation
//
//  Created by qp on 2020/12/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABNetUploadRequest.h"

@implementation ABNetUploadRequest
+ (ABNetUploadRequest *)createWithUri:(NSString *)uri params:(nonnull NSDictionary *)params data:(nonnull id)data key:(NSString *)key {
    ABNetUploadRequest *uploadRequest = [[ABNetUploadRequest alloc] init];
    uploadRequest.url = uri;
    uploadRequest.body = data;
    uploadRequest.key = @"file";
    return uploadRequest;
}
@end
