//
//  ABNetWorker.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABNetWorker.h"
#import <AFNetworking/AFNetworking.h>
#import "ABNetConfiguration.h"
@interface ABNetWorker ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) ABNetRequest *req;
@end
@implementation ABNetWorker
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPSessionManager alloc] init];
        //申明请求的数据是json类型
//        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //申明返回的结果是json类型
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 申明contentType
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",nil];
        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        self.isFree = true;
    }
    return self;
}
- (void)put:(ABNetRequest *)request {
    self.isFree = false;
    self.req = request;
    [self doRequest:self.req];
}

- (void)doRequest:(ABNetRequest *)request {
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
    [headers setValue:request.timestamp forKey:@"fk"];
    NSString *method = [request.method lowercaseString];

    NSString *url = [NSString stringWithFormat:@"%@%@", request.host, request.uri];
    NSDictionary *params = request.realParams;


    __weak typeof(self) weakSelf = self;
    if ([method isEqualToString:@"get"]) {
        NSURLSessionDataTask *task = [self.manager GET:url parameters:params headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf finishRequest:request responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

            NSString *info = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
            [self faillureRequest:request error:[NSError errorWithDomain:error.domain code:response.statusCode userInfo:@{NSLocalizedDescriptionKey:info}]];

        }];
        [self.delegate netWorkerBegin:self request:request task:task];
    }else{
        NSURLSessionDataTask *task = [self.manager POST:url parameters:params headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf finishRequest:request responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

            NSString *info = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
            [self faillureRequest:request error:[NSError errorWithDomain:error.domain code:response.statusCode userInfo:@{NSLocalizedDescriptionKey:info}]];
        }];

        [self.delegate netWorkerBegin:self request:request task:task];
    }
}

- (void)finishRequest:(ABNetRequest *)request responseObject:(NSDictionary *)responseObject {
    self.isFree = true;
    
    ABNetError *error = [[ABNetError alloc] initWithDic:responseObject];
    if (error.code == [ABNetConfiguration shared].provider.successCode) {
        NSString *dataKey = [ABNetConfiguration shared].provider.dataKey;
        if (dataKey == nil) {
            [self.delegate netWorkerFinish:self request:request responseObject:responseObject];
        }else{
            [self.delegate netWorkerFinish:self request:request responseObject:responseObject[dataKey]];
        }
        
    }else{
        
        
        self.isFree = true;
        [self.delegate netWorkerFailure:self request:request err:error];
        if ([ABNetConfiguration shared].provider.isDebugLog == false) {
            return;
        }
        
        NSMutableString *string = [[NSMutableString alloc] init];
        [string appendString:@"\n\n******************请求发送错误************************\n"];
        [string appendString:[NSString stringWithFormat:@"**CreateTime:%@\n", request.timestamp]];
        [string appendString:[NSString stringWithFormat:@"**From:%@\n", [request.target description]]];
        [string appendString:[NSString stringWithFormat:@"**Host:%@\n", request.host]];
        [string appendString:[NSString stringWithFormat:@"**Api:%@\n", request.uri]];
        [string appendString:[NSString stringWithFormat:@"**RealApi:%@\n", request.realUri]];
        [string appendString:[NSString stringWithFormat:@"**Method:%@\n", request.method]];
        [string appendString:[NSString stringWithFormat:@"**Headers:%@\n", request.headers]];
        [string appendString:[NSString stringWithFormat:@"**Params:%@\n", request.params]];
        [string appendString:[NSString stringWithFormat:@"**ReasonObject:%@\n", responseObject]];
        [string appendString:@"****************************************************\n\n"];
        
        fprintf(stderr, "%s", [string UTF8String]);
    }
}

- (void)faillureRequest:(ABNetRequest *)request error:(NSError *)err {
    self.isFree = true;
    ABNetError *error = [[ABNetError alloc] initWithError:err];
    [self.delegate netWorkerFailure:self request:request err:error];
    
    if ([ABNetConfiguration shared].provider.isDebugLog == false) {
        return;
    }
    
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"\n\n******************请求发送错误************************\n"];
    [string appendString:[NSString stringWithFormat:@"**CreateTime:%@\n", request.timestamp]];
    [string appendString:[NSString stringWithFormat:@"**From:%@\n", [request.target description]]];
    [string appendString:[NSString stringWithFormat:@"**Host:%@\n", request.host]];
    [string appendString:[NSString stringWithFormat:@"**Api:%@\n", request.uri]];
    [string appendString:[NSString stringWithFormat:@"**RealApi:%@\n", request.realUri]];
    [string appendString:[NSString stringWithFormat:@"**Method:%@\n", request.method]];
    [string appendString:[NSString stringWithFormat:@"**Headers:%@\n", request.headers]];
    [string appendString:[NSString stringWithFormat:@"**Params:%@\n", request.params]];
    [string appendString:[NSString stringWithFormat:@"**ReasonCode:%ld\n", (long)error.code]];
    [string appendString:[NSString stringWithFormat:@"**ReasonMessage:%@\n", error.message]];
    [string appendString:[NSString stringWithFormat:@"**ReasonXMessage:%@\n", err.localizedDescription]];
    [string appendString:@"****************************************************\n\n"];
    
    fprintf(stderr, "%s", [string UTF8String]);
}

@end
