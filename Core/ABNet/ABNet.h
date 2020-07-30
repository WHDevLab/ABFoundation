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
NS_ASSUME_NONNULL_BEGIN

@interface ABNet : NSObject
+ (ABNet *)shared;
@property (nonatomic, strong) id<ABNetPluginType> errorHandle;
- (void)push:(ABNetRequest *)req;
- (void)registerDataProcess:(id<ABNetPluginType>)process key:(NSString *)key;
- (void)ready;

- (void)uploadWithURL:(NSString *)url image:(UIImage *)image success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable responseObject))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

+ (BOOL)isNetReachable;
@end

NS_ASSUME_NONNULL_END
