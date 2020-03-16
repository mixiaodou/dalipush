#import "DalipushPlugin.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "MJExtension.h"

@interface DalipushPlugin() <FlutterStreamHandler>

@property (nonatomic, strong) FlutterEventSink eventSink;

@end

@implementation DalipushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"dalipush"
                                     binaryMessenger:[registrar messenger]];
    DalipushPlugin* instance = [[DalipushPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"dalipush_event" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
    
    [instance registerMessageReceive];
    
}


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
        NSString* alias = call.arguments[@"alias"];
        [self removeAlias:alias result:result];
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
      result([NSNumber numberWithBool:[CloudPushSDK isChannelOpened]]);
    } else if([@"turnOnPushChannel" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[CloudPushSDK isChannelOpened]]);
    } else {
      result(FlutterMethodNotImplemented);
    }
}

#pragma mark - FlutterStreamHandler

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)eventSink{
    self.eventSink = eventSink;
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments{
    return nil;
}

/**
 *    注册推送消息到来监听
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
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    
    NSLog(@"onMessageReceived userinfo : %@", notification.userInfo);
    
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"title"] = title;
    dict[@"body"] = body;
    NSString *jsonStr = [[dict mj_JSONString] copy];
    self.eventSink(jsonStr);
}



@end
