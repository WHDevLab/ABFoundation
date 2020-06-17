//
//  ABFileManager.h
//  ABFoundation
//
//  Created by qp on 2020/6/17.
//  Copyright © 2020 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABFileManager : NSObject
+ (NSDictionary *)readDicWithJSONFile:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
