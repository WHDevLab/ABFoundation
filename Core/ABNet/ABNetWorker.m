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
#import "IMService.h"
#import "NSDictionary+AB.h"
#import <sys/utsname.h>//要导入头文件
#import "ABTime.h"
@interface ABNetWorker ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) ABNetRequest *req;

@property (nonatomic, strong) IMService *service;
@property (nonatomic, strong) NSString *osinfo;
@end
@implementation ABNetWorker
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPSessionManager alloc] init];
        if ([[ABNetConfiguration shared].provider.contentType isEqualToString:@"application/json"]) {
            //申明请求的数据是json类型
            _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        } else {
            [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        }

        // 申明contentType
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain",nil];
        _manager.requestSerializer.timeoutInterval = [ABNetConfiguration shared].provider.timeoutInterval;
        self.isFree = true;
        
        AFJSONResponseSerializer *ser = [AFJSONResponseSerializer serializer];
        ser.removesKeysWithNullValues = true;
        _manager.responseSerializer = ser;
        
        NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        NSString *sysVersion = [UIDevice currentDevice].systemVersion;
        
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
        self.osinfo = [NSString stringWithFormat:@"app=zhibo;app_version=%@;platform=ios;sys_version=%@;model=%@", appVersion, sysVersion, deviceModel];
        
    }
    return self;
}
- (void)put:(ABNetRequest *)request {
    self.isFree = false;
    self.req = request;
    
    
    if ([[ABNetConfiguration shared].provider isTCPRequest:request]) {
        [self doTCPRequest:self.req];
    }
    if ([request.method isEqualToString:@"upload"]) {
        [self doUploadRequest:request];
    }
    else{
        [self doRequest:request];
    }
}

- (void)doTCPRequest:(ABNetRequest *)request {
    
    NSDictionary *headers = request.headers;
    self.service = [[IMService alloc] init];
//    service.host = [[request.host componentsSeparatedByString:@":"][0]];
    self.service.host = @"119.28.78.169";
    self.service.port = 24430;
//    service.port = [[request.host componentsSeparatedByString:@":"][1] intValue];
    self.service.deviceID = headers[@"uid"];
    self.service.token = headers[@"token"];
    [self.service start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RoomMessage *mm = [[RoomMessage alloc] init];
        mm.sender = 1;
        mm.receiver = 2;
        mm.content = [@{@"cmd":@"login", @"header":headers, @"body":@{}} toJSONString];
        [self.service sendRoomMessage:mm];

    });
    
    
//    service.host = [Stack shared].game_wsurl;
//    service.port = [Stack shared].game_tcpport;
//    service.heartbeatHZ = 30;
//    service.deviceID = [Service shared].account.gmuid;
//    service.token = [Service shared].account.gmtoken;
}

- (void)doUploadRequest:(ABNetRequest *)request {
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
    [headers setValue:request.timestamp forKey:@"fk"];
    [headers setValue:self.osinfo forKey:@"os"];
    NSString *method = [request.method lowercaseString];

    NSString *url = [NSString stringWithFormat:@"%@%@", request.host, request.realUri];
    NSDictionary *params = request.realParams;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/html",

                                                            @"image/jpeg",

                                                            @"image/png",

                                                            @"application/octet-stream",

                                                            @"text/json",

                                                            nil];
     [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:params headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<request.binarys.count; i++) {
            [formData appendPartWithFileData:request.binarys[i] name:request.binaryKey fileName:@"abc.jpg" mimeType:@"application/octet-stream"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld     ------ %lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
        CGFloat p = 1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        NSLog(@"%.2f", p);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf finishRequest:request responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self faillureRequest:request error:[NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey:@"错误"}]];
    }];
}

- (void)doRequest:(ABNetRequest *)request {
    NSLog(@"%@", request.uri);
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
    [headers setValue:request.timestamp forKey:@"fk"];
    [headers setValue:self.osinfo forKey:@"os"];
    NSString *method = [request.method lowercaseString];

    NSString *url = [NSString stringWithFormat:@"%@%@", request.host, request.realUri];
    NSDictionary *params = request.realParams;

    __weak typeof(self) weakSelf = self;
    if ([method isEqualToString:@"get"]) {
        NSURLSessionDataTask *task = [self.manager GET:url parameters:params headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf finishRequest:request responseObject:responseObject];
//            if ([responseObject isKindOfClass:[NSData class]]) {
//                NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                [strongSelf finishRequest:request responseObject:dd];
//            }else{
//                [strongSelf finishRequest:request responseObject:responseObject];
//            }
            
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
    NSString *codeKey = [[ABNetConfiguration shared].provider codeKey:request];
    NSString *msgKey = [[ABNetConfiguration shared].provider msgKey:request];
    if (codeKey == nil || msgKey == nil) {
        [self.delegate netWorkerFinish:self request:request responseObject:responseObject];
        return;
    }
    
    NSInteger successCodeValue = [[ABNetConfiguration shared].provider successCode:request];
    
    NSInteger codeValue = [responseObject[codeKey] integerValue];
    NSString *msgValue = responseObject[msgKey];
    request.msg = msgValue;
    
    if (codeValue == successCodeValue || responseObject[codeKey] == nil) {
        NSString *dataKey = [[ABNetConfiguration shared].provider dataKey:request];
        if (dataKey == nil) {
            [self.delegate netWorkerFinish:self request:request responseObject:responseObject];
        }else{
            NSLog(@"%@", responseObject[@"info"]);
            NSDictionary *res = responseObject[dataKey];
            
            if ([res isKindOfClass:[NSArray class]]) {
                [self.delegate netWorkerFinish:self request:request responseObject:@{@"list":res}];
            }else{
                [self.delegate netWorkerFinish:self request:request responseObject:res];
            }
        }
    }else{
        ABNetError *error = [[ABNetError alloc] init];
        error.code = codeValue;
        error.message = msgValue;
        error.uri = request.uri;
        self.isFree = true;
        [self.delegate netWorkerFailure:self request:request err:error];
        if ([ABNetConfiguration shared].provider.isDebugLog == false) {
            return;
        }
        
        NSMutableString *string = [[NSMutableString alloc] init];
        [string appendString:@"\n\n******************请求发生错误************************\n"];
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
        
        fprintf(stderr, "%s", [string UTF8String]);
    }
}

- (void)faillureRequest:(ABNetRequest *)request error:(NSError *)err {
    self.isFree = true;
    ABNetError *error = [[ABNetError alloc] initWithError:err];
    error.uri = request.uri;
    [self.delegate netWorkerFailure:self request:request err:error];
    
    if ([ABNetConfiguration shared].provider.isDebugLog == false) {
        return;
    }
    
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"\n\n******************请求发生错误************************\n"];
    [string appendString:[NSString stringWithFormat:@"**CreateTime:%@\n", request.timestamp]];
    [string appendString:[NSString stringWithFormat:@"**CreateTimeFormat:%@\n", [ABTime timestampToTime:request.timestamp format:@"yyyy-MM-dd hh:mm:ss"]]];
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
