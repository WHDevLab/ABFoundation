//
//  ABUtils.h
//  ABFoundation
//
//  Created by qp on 2020/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABUtils : NSObject
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
