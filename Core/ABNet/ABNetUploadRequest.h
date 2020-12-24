//
//  ABNetUploadRequest.h
//  ABFoundation
//
//  Created by qp on 2020/12/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetUploadObjectResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface ABNetUploadRequest : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *object;
@property (nonatomic, strong) NSData *body;
@property (nonatomic, strong) NSDictionary *headers;
- (void)setFinishBlock:(void (^_Nullable)(ABNetUploadObjectResult *_Nullable, NSError *_Nullable))ABNetUploadRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
