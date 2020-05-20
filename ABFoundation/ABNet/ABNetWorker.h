//
//  ABNetWorker.h
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABNetRequest.h"
#import "ABNetError.h"
NS_ASSUME_NONNULL_BEGIN
@class ABNetWorker;
@protocol ABNetWorkerDelegate <NSObject>

- (void)netWorkerBegin:(ABNetWorker *)worker request:(ABNetRequest *)request task:(NSURLSessionTask *)task;
- (void)netWorkerFinish:(ABNetWorker *)worker request:(ABNetRequest *)request responseObject:(NSDictionary *)responseObject;
- (void)netWorkerFailure:(ABNetWorker *)worker request:(ABNetRequest *)request err:(ABNetError *)err;

@end

@interface ABNetWorker : NSObject
@property (nonatomic, weak) id<ABNetWorkerDelegate> delegate;
@property (nonatomic, assign) BOOL isFree;
- (void)put:(ABNetRequest *)request;
- (void)doRequest:(ABNetRequest *)request;
- (void)finish:(NSDictionary *)responseObject;
@end

NS_ASSUME_NONNULL_END
