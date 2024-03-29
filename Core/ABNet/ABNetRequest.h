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
    ABNetRequestCachePolicyCacheDataElseLoad,//有缓存用缓存，没有就请求
    ABNetRequestCachePolicyCacheDataDontLoad, //直接使用缓存,不请求
    ABNetRequestCachePolicyCacheDataAndLoad //先载入缓存,然后继续请求
} ABNetRequestCachePolicy;


typedef enum : NSUInteger {
    ABNetRequestStatusNormal,
    ABNetRequestStatusTombstone,
    ABNetRequestStatusFinish,
}ABNetRequestStatus;

@interface ABNetRequest : NSObject
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *putUrl;
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
@property (nonatomic, strong) NSString *responseContentType;

//用于上传文件
@property (nonatomic, strong) NSString *binaryKey; //服务端读取二进制的key，eg:file
@property (nonatomic, strong) NSArray<NSData *> *binarys; //二进制数组

///网络请求是否随着target释放而取消
@property (nonatomic, assign) BOOL isCancelWhenTargetDealloc;

- (void)ready;

- (BOOL)isExpire;

+ (ABNetRequest *)getUri:(NSString *)uri params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
