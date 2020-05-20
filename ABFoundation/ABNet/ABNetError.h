//
//  ABNetError.h
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABNetError : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;

- (ABNetError *)initWithError:(NSError *)error;
- (ABNetError *)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
