//
//  ViewController.m
//  ABFoundation
//
//  Created by qp on 2020/5/20.
//  Copyright © 2020 abteam. All rights reserved.
//

#import "ViewController.h"
#import "ABFoundation.h"
@interface ViewController ()<INetData, IABMQSubscribe>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self testABNet];
    [self testABMQ];
}


#pragma mark ---- test abnet ---------

- (void)testABNet {
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


#pragma mark --------

- (void)testABMQ {
    [[ABMQ shared] subscribe:self channel:@"test" autoAck:false];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ABMQ shared] publish:@"nihao" channel:@"test"];
    });
}

- (void)onReceiveMessageFromMQ:(id)message {
    NSLog(@"%@", message);
    [[ABMQ shared] ack:self];
}
@end
