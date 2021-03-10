//
//  ABNet.h
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetRequest.h"
#import "ABNetPlugin.h"
#import "ABNetUploadRequest.h"
NS_ASSUME_NONNULL_BEGIN
@interface ABNet : NSObject
+ (ABNet *)shared;
@property (nonatomic, strong) id<ABNetPluginType> errorHandle;
@property (nonatomic, strong) NSMutableArray<id<ABNetPluginType>> *plugins;
@property (nonatomic, strong) NSMutableArray *logs;
- (void)push:(ABNetRequest *)req;
- (void)pushUpload:(ABNetUploadRequest *)req;
- (void)registerDataProcess:(id<ABNetPluginType>)process key:(NSString *)key;
- (void)registerPlugin:(NSString *)plugin;
/**
 注册网络请求拦截器（2.0）
 
 @param intercept 类名<ABNetPluginType>
 @param route 路由地址
 */
- (void)registerIntercept:(NSString *)intercept route:(NSString *)route;
- (void)ready;

+ (void)uploadWithURL:(NSString *)url params:(NSDictionary *)params files:(NSArray<NSDictionary<NSString*,id>*>*)fileDatas success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable responseObject))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

- (BOOL)isNetReachable;
- (void)uploadObject:(ABNetUploadRequest *)request;

- (void)startNetListen:(void (^)(BOOL isReachable))block;
@end

NS_ASSUME_NONNULL_END
