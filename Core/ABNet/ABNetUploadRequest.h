//
//  ABNetUploadRequest.h
//  ABFoundation
//
//  Created by qp on 2020/12/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetUploadObjectResult.h"
#import "ABNetRequest.h"
NS_ASSUME_NONNULL_BEGIN
@interface ABNetUploadRequest : NSObject
@property (nonatomic, strong) NSString *url;
// 对象键，用于后端取值
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSData *body;
@property (nonatomic, weak) id<INetData> target;

+ (ABNetUploadRequest *)createWithUri:(NSString *)uri params:(NSDictionary *)params data:(id)data key:(NSString *)key;

//@property (nonatomic, strong) NSDictionary *headers;
- (void)setFinishBlock:(void (^_Nullable)(ABNetUploadObjectResult *_Nullable, NSError *_Nullable))ABNetUploadRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
