//
//  ABSecrect.h
//  ABFoundation
//
//  Created by qp on 2021/3/18.
//  Copyright © 2021 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ABSecrectTypeAES,
    ABSecrectTypeRSA,
    ABSecrectTypeDES,
} ABSecrectType;

@interface ABSecrect : NSObject
+ (ABSecrect *)shared;
/**
 Returns an encrypted NSData using AES.
 
 @param key   A key length of 16, 24 or 32 (128, 192 or 256bits).
 
 @param iv    An initialization vector length of 16(128bits).
              Pass nil when you don't want to use iv.
 
 @return      An NSData encrypted, or nil if an error occurs.
 */
- (NSData *)decryptAESData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;

/**
 Returns an decrypted NSData using AES.
 
 @param key   A key length of 16, 24 or 32 (128, 192 or 256bits).
 
 @param iv    An initialization vector length of 16(128bits).
              Pass nil when you don't want to use iv.
 
 @return      An NSData decrypted, or nil if an error occurs.
 */
- (NSData *)encryptAESData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;
- (NSString *)decryptAESDataString:(NSString *)string key:(NSString *)key iv:(NSString *)iv;
@end

NS_ASSUME_NONNULL_END
