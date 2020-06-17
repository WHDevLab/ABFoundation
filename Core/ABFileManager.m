//
//  ABFileManager.m
//  ABFoundation
//
//  Created by qp on 2020/6/17.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ABFileManager.h"

@implementation ABFileManager
+ (NSDictionary *)readDicWithJSONFile:(NSString *)name {
    @try {
        NSString *path = [NSBundle.mainBundle pathForResource:name ofType:@"json"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        return dic;
    }
    @catch (NSException *exception) {
        NSLog(@"@NSException");
        NSLog(@"%@", exception);
    }
    @finally {
        NSLog(@"@finally");
    }
}
@end
