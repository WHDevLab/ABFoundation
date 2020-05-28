//
//  ABWeakObject.h
//  ABFoundation
//
//  Created by qp on 2020/5/25.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABWeakObject : NSObject
@property (nonatomic, weak) id obj;
- (instancetype)initWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
