//
//  ViewController.m
//  ABFoundation
//
//  Created by qp on 2020/5/20.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ViewController.h"
#import "ABFoundation.h"
@interface ViewController ()<INetData>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [ABNetConfiguration shared].provider.host = @"http://v.juhe.cn";
    [ABNetConfiguration shared].provider.isDebugLog = false;
    [ABNetConfiguration shared].provider.codeKey = @"resultcode";
    [ABNetConfiguration shared].provider.msgKey = @"reason";
    
    [self fetchUri:@"/joke/content/list.php" params:@{}];
}

- (void)onNetRequestSuccess:(ABNetRequest *)req obj:(NSDictionary *)obj isCache:(BOOL)isCache {
    NSLog(@"%@", obj);
}

- (void)onNetRequestFailure:(ABNetRequest *)req err:(ABNetError *)err {
    NSLog(@"%@", err.des);
}
@end
