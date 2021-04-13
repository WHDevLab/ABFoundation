ABFoundation是一个iOS常用的逻辑功能(非UI)的集合

UI库 [ABUIKit](https://github.com/whdevlab/ABUIKit)

# 安装

如何集成到你的项目

### 使用cocopods引入

```
pod 'ABFoundation', :git => "https://github.com/whdevlab/ABFoundation"
```

# 使用

这里只展示部分功能的使用案例

### ABNet
ABNet是基于 AFNetworking 封装的 iOS 网络库

-  支持请求去重。根据请求uri及参数生成唯一标识(identifier)标记一个请求
-  支持数据缓存。可设置不同策略值，带来不同的缓存效果
-  支持整个请求-响应环节的关键点拦截。只需遵守ABNetPluginType协议即可，可在关键点处理例如loading、请求uri重定向、参数修改、响应数据验证修改，统一的错误处理等操作。
-  支持批量的网络请求发送。会有消息队列去处理这一切
-  支持单文件及多文件上传。只需输入一个二进制列表及服务器接受文件的key
-  支持快捷调用。所有继承自NSObject的子类都可用

#### 简单调用示例

```
@interface DetailViewController ()<INetData>
@end
@implementation ProductDetailViewController
- (void)viewDidLoad {
	// uri可通过定义宏来统一
	//get
	[self fetchUri:@"/order/detail" params:@{@"order_sn":@"123456"}]; 
	//post
	[self fetchPostUri:@"/order/detail" params:@{@"order_sn":@"123456"}]; 
}

//INetData 协议，请求成功的回调
- (void)onNetRequestSuccess:(ABNetRequest *)req obj:(NSDictionary *)obj isCache:(BOOL)isCache {
	// do something
}

//请求失败回调(一般走统一的ABNetPluginType错误处理类)
- (void)onNetRequestFailure:(ABNetRequest *)req err:(ABNetError *)err{
	// do something
}
@end
```
例如: 统一拦截处理所有order类的请求

```
@interface OrderIntercept : NSObject<ABNetPluginType>
@end
@implementation OrderIntercept
/// 请求准备阶段
- (ABNetRequest *)prepare:(ABNetRequest *)request {
    if ([request.uri isEqualToString:@"/order/list"]) {
        //request.uri 只是本地路由地址
        //request.realUri为真实的服务器请求地址
        request.realUri = @"/sale_list"; 
    }
    return request;
}
/// 请求即将发出
- (void)willSend:(ABNetRequest *)request {
    
}
/// 请求结束。得到响应或发生异常
- (void)endSend:(ABNetRequest *)request {
   
}

/// 请求结束。得到响应，可对数据做处理
- (NSDictionary *)process:(ABNetRequest *)request response:(NSDictionary *)response {
    if ([request.uri isEqualToString:@"/order/list"]) {
    	  //ABIteration为当前库提供的迭代器
        NSMutableArray *dataList = [ABIteration iterationList:response[@"list"] block:^NSMutableDictionary * _Nonnull(NSMutableDictionary * _Nonnull dic, NSInteger idx) {
        	// 这里配合ABUIKit库做view-data绑定操作
            dic[@"native_id"] = @"ordersaleitem";
            	//格式化时间
            dic[@"data.time"] = [ABTime timestampToTime:[dic stringValueForKey:@"creatime"] format:@"MM-dd mm:ss"];
            return dic;
        }];
        return @{@"list":dataList};
    }
    return response;
}
//// 请求结束。发生错误
- (void)didReceiveError:(ABNetRequest *)request error:(ABNetError *)error {
    
}
```
为OrderIntercept绑定路由(可在appdelegte, didFinishLaunchingWithOptions中做这些)

```
[[ABNet shared] registerIntercept:@"OrderIntercept" route:@"/order"];
```
之后所有uri前缀为order的请求都会达到这个拦截类。同时为了满足统一loading的需求，也可注册一个插件到ABNet，所有的请求都会到达，同样需遵守ABNetPlugin协议，只是注册的方式不同，如下

```
[[ABNet shared] registerPlugin:@"LoadingPlugin"];
```
> registerPlugin 和 registerIntercept互不影响，order请求两个都会到达，虽然都是继承ABNetPluginType，但需要做好职责分配。
> 


### ABMQ 
基于发布订阅机制的消息队列
发布

```
//channel 可用于区分发送渠道
//[[ABMQ shared] publish:<#(nonnull id)#> channel:<#(nonnull NSString *)#>]
[[ABMQ shared] publish:@"hello" channel:@"order"];
```
接收

```
// 接受指定渠道的消息
// subscribe 订阅者。需遵守IABMQSubscribe协议
// autoAck 是否自动回复。只有回复后消息队列才会继续推送下条消息
//[[ABMQ shared] subscribe:<#(nonnull id<IABMQSubscribe>)#> channel:<#(nonnull NSString *)#> autoAck:<#(BOOL)#>]
[[ABMQ shared] subscribe:self channel:@"order" autoAck:true];

//IABMQSubscribe协议。订阅消息接收
- (void)abmq:(ABMQ *)abmq onReceiveMessage:(id)message channel:(NSString *)channel {
	//手动回复。autoAck为true可忽略
	[[ABMQ shared] ack:self];
}
```
### ABRedis
全局单例缓存类，并在合适的时机(比如进后台)持久化至本地

应用初始化完毕需载入数据

```
[[ABRedis shared] load];
```

设置

```
[ABRedis shared] set:@"aaa" key:@"name"];
```
获取

```
[ABRedis shared] get:@"name"];
```


### ABLanguage
国际化

language.json

```
{
	"PAY_PWD":{
		"cn":"支付密码",
		"en":"Pay Password"
	},
	"LOGIN_PWD":{
		"cn":"登录密码",
		"en":"Login Password"
	},}
```

载入language.json至ABLanguage

```
[ABLanguage shared].dataMap = [ABFileManager readDicWithJSONFile:@"language"];
```

切换语言

```
[[ABRedis shared] set:@"en" key:@"lang"];
[[ABLanguage shared] changedLanguage];
```

使用

```
label.text = [@"PAY_PWD" localized];
```
