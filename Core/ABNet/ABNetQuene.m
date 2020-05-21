//
//  ABNetQuene.m
//  Demo
//
//  Created by qp on 2020/5/18.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABNetQuene.h"
@interface ABNetQuene ()<ABNetWorkerDelegate>
@property (nonatomic, strong) NSMutableArray<ABNetRequest *> *stack;
@property (nonatomic, strong) NSMutableArray<ABNetWorker *> *ABNetWorkers;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSURLSessionTask *> *taskMap;

@end
@implementation ABNetQuene
+ (ABNetQuene *)shared {
    static ABNetQuene *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ABNetWorkers = [[NSMutableArray alloc] init];
        self.taskMap = [[NSMutableDictionary alloc] init];
        self.stack = [[NSMutableArray alloc] init];
        self.httpMaximumConnectionsPerHost = 4;
    }
    return self;
}

- (void)setHttpMaximumConnectionsPerHost:(NSInteger)httpMaximumConnectionsPerHost {
    _httpMaximumConnectionsPerHost = httpMaximumConnectionsPerHost;
    @synchronized (self.ABNetWorkers) {
        [self.ABNetWorkers removeAllObjects];
        for (int i=0; i<self.httpMaximumConnectionsPerHost; i++) {
            ABNetWorker *worker = [[ABNetWorker alloc] init];
            worker.delegate = self;
            [self.ABNetWorkers addObject:worker];
        }
    }
}

- (void)put:(ABNetRequest *)request {
    //取消重复请求
    [self.taskMap[request.identifier] cancel];
    [self.taskMap removeObjectForKey:request.identifier];
    
    //先进后出，照顾用户最新的操作
    [self.stack insertObject:request atIndex:0];
    [self consumQuene];

}

- (void)consumQuene {
    for (ABNetWorker *worker in self.ABNetWorkers) {
        if (worker.isFree) {
            for (ABNetRequest *req in self.stack) {
                if (req.owner == nil) {
                    req.owner = worker;
                    [worker put:req];
                }
            }
        }
    }
}

- (void)clean {
    for (ABNetRequest *request in self.stack) {
        if (request.target == nil && request.isCancelWhenTargetDealloc) {
            [self.taskMap[request.identifier] cancel];
            [self.taskMap removeObjectForKey:request.identifier];
        }
    }
}

- (void)netWorkerBegin:(ABNetWorker *)ABNetWorker request:(ABNetRequest *)request task:(NSURLSessionTask *)task {
    self.taskMap[request.identifier] = task;
    
}

- (void)netWorkerFinish:(ABNetWorker *)ABNetWorker request:(ABNetRequest *)request responseObject:(NSDictionary *)responseObject {
    [self callBackSucess:request responseObject:responseObject];
    [self.stack removeObject:request];
}

- (void)netWorkerFailure:(ABNetWorker *)ABNetWorker request:(ABNetRequest *)request err:(ABNetError *)err {
    [self callBackFailure:request error:err];
}

- (void)callBackSucess:(ABNetRequest *)request responseObject:(NSDictionary *)responseObject {
    if (request.handleTarget != nil) {
        [request.handleTarget onNetRequestSuccess:request obj:responseObject isCache:false];
    }else{
        [request.target onNetRequestSuccess:request obj:responseObject isCache:false];
    }
}

- (void)callBackFailure:(ABNetRequest *)request error:(ABNetError *)err {
    if (request.handleTarget != nil) {
        [request.handleTarget onNetRequestFailure:request err:err];
    }else{
        [request.target onNetRequestFailure:request err:err];
    }
}

@end
