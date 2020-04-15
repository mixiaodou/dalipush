#import "DalipushPlugin.h"
#import <UserNotifications/UserNotifications.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import "MJExtension.h"

@interface DalipushPlugin() <FlutterStreamHandler>

@property (nonatomic, strong) FlutterEventSink eventSink;

@end

@implementation DalipushPlugin {
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"dalipush"
                                     binaryMessenger:[registrar messenger]];
    DalipushPlugin* instance = [[DalipushPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"dalipush_event" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
    [registrar addApplicationDelegate:instance];
    
//    [instance registerMessageReceive];
    
}

UNNotificationPresentationOptions _notificationPresentationOption = UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge;
NSMutableArray *events = nil;


- (void)addAlias:(NSString *)alias result:(FlutterResult)result {
    [CloudPushSDK addAlias:alias withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            result(res.data);
        } else {
            result(res.error);
        }
    }];
}

- (void)removeAlias:(NSString *)alias result:(FlutterResult)result {
    [CloudPushSDK removeAlias:alias withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            result(res.data);
        } else {
            result(res.error);
        }
    }];
}

- (void)bindAccount:(NSString *)account result:(FlutterResult)result {
    [CloudPushSDK bindAccount:account withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            result(res.data);
        } else {
            result(res.error);
        }
    }];
}

- (void)unbindAccount:(FlutterResult)result {
    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
        if (res.success) {
            result(res.data);
        } else {
            result(res.error);
        }
    }];
}

- (void)bindTags:(int)target withTags:(NSArray *)tags alias:(NSString *)alias result:(FlutterResult)result {
    [CloudPushSDK bindTag:target withTags:tags withAlias:alias withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            result(res.data);
        } else {
            result(res.error);
        }
    }];
}

- (void)unbindTag:(int)target withTags:(NSArray *)tags alias:(NSString *)alias result:(FlutterResult)result {
    [CloudPushSDK unbindTag:target withTags:tags withAlias:alias withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            result(res.data);
        } else {
            result(res.error);
        }
    }];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"getDeviceId" isEqualToString:call.method]) {
        result([CloudPushSDK getDeviceId]);
    } else if([@"getDeviceToken" isEqualToString:call.method]) {
        result([CloudPushSDK getApnsDeviceToken]);
    } else if([@"clearNotifications" isEqualToString:call.method]) {
        result(nil);
    } else if([@"closeDoNotDisturbMode" isEqualToString:call.method]) {
        result(nil);
    } else if([@"addAlias" isEqualToString:call.method]) {
        NSString* alias = call.arguments[@"alias"];
        [self addAlias:alias result:result];
    } else if([@"removeAlias" isEqualToString:call.method]) {
        NSString* alias = call.arguments[@"alias"];
        [self removeAlias:alias result:result];
    } else if([@"bindAccount" isEqualToString:call.method]) {
        NSString* account = call.arguments[@"account"];
        [self bindAccount:account result:result];
    } else if([@"unbindAccount" isEqualToString:call.method]) {
        [self unbindAccount:result];
    } else if([@"bindPhoneNumber" isEqualToString:call.method]) {
        result(nil);
    } else if([@"unbindPhoneNumber" isEqualToString:call.method]) {
        result(nil);
    } else if ([@"bindTag" isEqualToString:call.method]) {
        int target = [call.arguments[@"target"] intValue];
        NSArray* tags = call.arguments[@"tags"];
        NSString* alias = call.arguments[@"alias"];
       [self bindTags:target withTags:tags alias:alias result:result];
    } else if ([@"unbindTag" isEqualToString:call.method]) {
      int target = [call.arguments[@"target"] intValue];
       NSArray* tags = call.arguments[@"tags"];
       NSString* alias = call.arguments[@"alias"];
      [self unbindTag:target withTags:tags alias:alias result:result];
    } else if([@"checkPushChannelStatus" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[CloudPushSDK isChannelOpened]]);
    } else if([@"turnOffPushChannel" isEqualToString:call.method]) {
      NSString* bundleId = call.arguments[@"bundleId"];
        [self openSetting:bundleId];
      result(nil);
    } else if([@"turnOnPushChannel" isEqualToString:call.method]) {
        NSString* bundleId = call.arguments[@"bundleId"];
        [self openSetting:bundleId];
      result(nil);
    } else if([@"configureNotificationPresentationOption" isEqualToString:call.method]){
        [self configureNotificationPresentationOption:call result:result];
    } else {
      result(FlutterMethodNotImplemented);
    }
}

#pragma mark - FlutterStreamHandler

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)eventSink{
    self.eventSink = eventSink;
    if (events != nil) {
        NSEnumerator* enumerateor =  [events objectEnumerator];

        NSMutableDictionary* result;
        while (result = [enumerateor nextObject]) {
            self.eventSink(result);
        }
        [events removeAllObjects];
        events = nil;
    }
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments{
    self.eventSink = nil;
    return nil;
}

///**
// *    注册推送消息到来监听
// */
//- (void)registerMessageReceive {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onMessageReceived:)
//                                                 name:@"CCPDidReceiveMessageNotification"
//                                               object:nil];
//}
///**
// *    处理到来推送消息
// *
// *    @param     notification
// */
//- (void)onMessageReceived:(NSNotification *)notification {
//    
//    NSLog(@"onMessageReceived userinfo : %@", notification.userInfo);
//    
//    CCPSysMessage *message = [notification object];
//    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
//    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
//    NSLog(@"Receive message title: %@, content: %@.", title, body);
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    dict[@"title"] = title;
//    dict[@"body"] = body;
//    NSString *jsonStr = [[dict mj_JSONString] copy];
//    self.eventSink(jsonStr);
//}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    _launchOptions = launchOptions;
    [self registerAPNS:application];
    [self initCloudPush];
    [self listenerOnChannelOpened];
    [self registerMessageReceive];
    [CloudPushSDK sendNotificationAck:launchOptions];

    return NO;
}


#pragma mark APNs Register

/**
 *    向APNs注册，获取deviceToken用于推送
 *
 *    @param     application
 */

- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        if (@available(iOS 10.0, *)) {
            _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        } else {
            // Fallback on earlier versions
        }
        // 创建category，并注册到通知中心
//        [self createCustomNotificationCategory];
        _notificationCenter.delegate = self;
        // 请求推送权限
        if (@available(iOS 10.0, *)) {
            [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError *_Nullable error) {
                if (granted) {
                    // granted
                    NSLog(@"User authored notification.");
                    // 向APNs注册，获取deviceToken
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [application registerForRemoteNotifications];
                    });
                } else {
                    // not granted
                    NSLog(@"User denied notification.");
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
                [UIUserNotificationSettings settingsForTypes:
                                (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                  categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
}

/**
 *  主动获取设备通知是否授权(iOS 10+)
 */
- (void)getNotificationSettingStatus {
    if (@available(iOS 10.0, *)) {
        [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *_Nonnull settings) {
            if (@available(iOS 10.0, *)) {
                if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                    NSLog(@"User authed.");
                } else {
                    NSLog(@"User denied.");
                }
            } else {
                // Fallback on earlier versions
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

/*
 *  APNs注册成功回调，将返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Upload deviceToken to CloudPush server.");
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}

/*
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}


#pragma mark SDK Init

- (void)initCloudPush {
    // 正式上线建议关闭
    [CloudPushSDK turnOnDebug];

    // SDK初始化，无需输入配置信息
    // 请从控制台下载AliyunEmasServices-Info.plist配置文件，并正确拖入工程
    [CloudPushSDK autoInit:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

#pragma mark Channel Opened

/**
 *    注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];

}


/**
*    推送通道打开回调
*
*/
- (void)onChannelOpened:(NSNotification *)notification {
}


#pragma mark Receive Message

/**
 *    @brief    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

/**
 *    处理到来推送消息
 *
 */
- (void)onMessageReceived:(NSNotification *)notification {

    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
//    NSLog(@"Receive message title: %@, content: %@.", title, body);


    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            dict[@"title"] = title;
            dict[@"summary"] = body;
            dict[@"event"] = @"onMessage";
            
            self.eventSink(dict);
        });
    } else {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict[@"title"] = title;
        dict[@"summary"] = body;
        dict[@"event"] = @"onMessage";
        self.eventSink(dict);
    }
}


/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification event:(NSString*)event  API_AVAILABLE(ios(10.0)){

    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;

    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 同步角标数到服务端
    // [self syncBadgeNum:0];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);

    if (title != nil) {
        result[@"title"] = title;
    }

    if (body != nil) {
        result[@"summary"] = body;
    }

    if (subtitle != nil) {
        result[@"subtitle"] = subtitle;
    }

//    if (badge != nil) {
//        result[@"badge"] = @(badge);
//    }


    if (request.identifier != nil) {
        result[@"messageId"] = request.identifier;
    }
    result[@"event"] = event;
    
    if (userInfo != nil) {
        result[@"extraMap"] = userInfo;
    }

    if (![NSThread isMainThread] && self.eventSink != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.eventSink(result);
        });
    } else if (self.eventSink != nil) {
        self.eventSink(result);
    } else {
        if (events == nil) {
            events = [[NSMutableArray alloc] init];
        }
        [events addObject:result];
    }
//    NSString *jsonStr = [[dict mj_JSONString] copy];
    

//    [_methodChannel invokeMethod:@"onNotification" arguments:result];
}


/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知，并上报通知打开回执
    if (@available(iOS 10.0, *)) {
        [self handleiOS10Notification:notification event:@"onNotificationReceivedInApp"];
        completionHandler(_notificationPresentationOption);
    } else {
        // Fallback on earlier versions
    }
}


/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
//        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification event:@"onNotificationOpened"];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        [self handleiOS10Notification:response.notification event:@"onNotificationRemoved"];
//        [_methodChannel invokeMethod:@"onNotificationRemoved" arguments:response.notification.request.identifier];
//        NSLog(@"User dismissed the notification.");
    }
    completionHandler();
}


- (void)configureNotificationPresentationOption:(FlutterMethodCall *)call result:(FlutterResult)result {
//    {"none": none, "sound": sound, "alert": alert, "badge": badge});

    BOOL none = [call.arguments[@"none"] boolValue];
    if(none){
        _notificationPresentationOption = _notificationPresentationOption|UNNotificationPresentationOptionNone;
    }

    BOOL sound = [call.arguments[@"sound"] boolValue];
    if(sound){
        _notificationPresentationOption = _notificationPresentationOption |UNNotificationPresentationOptionSound;
    }

    BOOL alert = [call.arguments[@"alert"] boolValue];
    if(alert){
        _notificationPresentationOption = _notificationPresentationOption | UNNotificationPresentationOptionAlert;
    }

    BOOL badge = [call.arguments[@"badge"] boolValue];
    if(badge){
        _notificationPresentationOption = _notificationPresentationOption | UNNotificationPresentationOptionBadge;
    }

    result(@YES);
}

/** 跳转系统设置方法*/
- (void)openSetting:(NSString*)buddleId
{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    } else {
　　}
}

@end
