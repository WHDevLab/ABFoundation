//
//  ABNetQuene.h
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetRequest.h"
#import "ABNetWorker.h"
NS_ASSUME_NONNULL_BEGIN

@interface ABNetQuene : NSObject
@property (nonatomic, assign) NSInteger httpMaximumConnectionsPerHost;
- (void)put:(ABNetRequest *)request;
+ (ABNetQuene *)shared;
@end

NS_ASSUME_NONNULL_END
