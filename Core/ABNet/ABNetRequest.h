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


typedef enum : NSUInteger {
    ABNetRequestStatusNormal,
    ABNetRequestStatusTombstone,
    ABNetRequestStatusFinish,
}ABNetRequestStatus;

@interface ABNetUploadRequest : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *object;
@property (nonatomic, strong) NSData *body;
@end

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
@property (nonatomic) ABNetRequestStatus status;
@property (nonatomic) NSString *msg;
@property (nonatomic) ABNetRequestCachePolicy cachePolicy;
@property (nonatomic, assign) NSInteger timeout;
@property (nonatomic, assign) BOOL isShowLoading;
@property (nonatomic, assign) BOOL isWaitingNet;
@property (nonatomic, assign) BOOL canSend;

///网络请求是否随着target释放而取消
@property (nonatomic, assign) BOOL isCancelWhenTargetDealloc;

- (void)ready;

- (BOOL)isExpire;
@end

NS_ASSUME_NONNULL_END
