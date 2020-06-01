//
//  ABMQSubscibe.h
//  ABFoundation
//
//  Created by qp on 2020/5/23.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABWeakObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface ABMQSubscibe : ABWeakObject
@property (nonatomic, strong) NSMutableArray *quene;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, assign) BOOL autoAck;
@property (nonatomic, strong) NSMutableArray *channels;
- (id)next;
- (void)pop;
- (void)free:(BOOL)must;
- (void)append:(id)message;
@end

NS_ASSUME_NONNULL_END
