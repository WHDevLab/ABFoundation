//
//  NSObject+Language.h
//  ABFoundation
//
//  Created by qp on 2021/3/10.
//  Copyright © 2021 abteam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Language)
- (void)listenLanguageChanged;
@property (nonatomic, strong) NSString *langKey;
@end

NS_ASSUME_NONNULL_END
