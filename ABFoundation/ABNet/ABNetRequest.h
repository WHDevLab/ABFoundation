//
//  ABNetRequest.h
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetError.h"
NS_ASSUME_NONNULL_BEGIN
@class ABNetRequest;
@protocol INetData <NSObject>
- (void)onNetRequestSuccess:(ABNetRequest *)req obj:(NSDictionary *)obj isCache:(BOOL)isCache;
@optional
- (void)onNetRequestFailure:(ABNetRequest *)req err:(ABNetError *)err;
@end

typedef enum : NSUInteger {
    ABNetRequestCachePolicyNone,
    ABNetRequestCachePolicyCacheDataElseLoad,
    ABNetRequestCachePolicyCacheDataDontLoad,
    ABNetRequestCachePolicyCacheDataAndLoad
} ABNetRequestCachePolicy;

@interface ABNetRequest : NSObject
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSString *realUri;
@property (nonatomic, strong) NSDictionary *realParams;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, weak) id owner;
@property (nonatomic, weak) id<INetData> handleTarget;
@property (nonatomic, weak) id<INetData> target;

@property (nonatomic, strong) NSString *identifier;

///网络请求是否随着target释放而取消
@property (nonatomic, assign) BOOL isCancelWhenTargetDealloc;

- (void)ready;
@end

NS_ASSUME_NONNULL_END
