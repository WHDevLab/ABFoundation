//
//  ABWeakObject.m
//  ABFoundation
//
//  Created by qp on 2020/5/25.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABWeakObject.h"

@implementation ABWeakObject
- (instancetype)initWithTarget:(id)target {
    self.obj = target;
    return self;
}
@end
