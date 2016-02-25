//
//  AppDelegate.m
//  fitplus
//
//  Created by 天池邵 on 15/6/25.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfo.h"
#import "UserInfoModel.h"
#import "RequestCacher.h"
#import <AFNetworking.h>
#import "CommonsDefines.h"
#import "UserInfoModel.h"
#import "RBBlockAlertView.h"
#import <TuSDK/TuSDK.h>
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>
#import <ShareSDK/ShareSDK.h>
#import "RBBlockAlertView.h"
#import "Util.h"
#import "RBNoticeHelper.h"
#import "MessageUnreadCommentModel.h"
#import "MobClick.h"

//static NSString *const GTAppId     = @"89iAuzn92X9295QWLArah2";
//static NSString *const GTAppKey    = @"HuUA4GoyQF7NfjeZXszUC5";
//static NSString *const GTAppSecret = @"oJOLjOkkgB7VpVBAQlHax4";

static NSString *const UMAppKey = @"559e197b67e58e35fd00326c";

static NSString *const ShareSDKAppKey = @"8c05e56712b4";

static NSString *const TUSDKAppKey = @"bd9115a2e79300ce-00-oimln1";

@interface AppDelegate ()

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *openID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *headportrait;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *unionid;

@property (copy, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self initAppearance];
    [self initShareSDK];
    [self checkUpdate];
    [WXApi registerApp:wxAppKey];
    [TuSDK initSdkWithAppKey:TUSDKAppKey];
    //[Fabric with:@[CrashlyticsKit]];
    [MobClick startWithAppkey:UMAppKey reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [self startSdkWith:GeTuiAppId appKey:GeTuiAppKey appSecret:GeTuiAppSecret];
    
    if ([UserInfo userHaveLogin]) {
        [self initPush];
    }
    NSDictionary *message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@,%@", [NSDate date], payloadMsg];
        NSLog(@"%@", record);
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timerSchedule) userInfo:nil repeats:YES];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UserInfoModel updateDeviceToken:token handler:^(id object, NSString *msg) {
        if (msg) {
            NSLog(@"update device token failed %@", msg);
        }
    }];
    [GeTuiSdk registerDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"fail to register for remote notification : %@", error.description);
    [GeTuiSdk registerDeviceToken:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([[userInfo allKeys] containsObject:@"message"] && [[userInfo[@"message"] allKeys] containsObject:@"system_notice"]) {
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowGeTui" object:@YES];
    
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
}
- (void)timerSchedule {
    [MessageUnreadCommentModel unreadMessage:^(MessageUnreadCommentModel *object, NSString *msg) {
        NSInteger comment = [object.comment_num integerValue];
        NSInteger like = [object.favorite_num integerValue];
        if (comment + like > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedMessagesNotificationKey object:@(comment + like)];
        }
    }];
}
- (void)initShareSDK {
    [ShareSDK registerApp:ShareSDKAppKey];
    
    [ShareSDK connectWeChatWithAppId:wxAppKey
                           wechatCls:[WXApi class]];
    
}

- (void)initPush {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self registerNofitication];
}

- (void)registerNofitication {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8 ) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil]];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)initAppearance {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.234 green:0.180 blue:0.292 alpha:1.000]];
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 0.0f);
    shadow.shadowColor = [UIColor clearColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                                            NSShadowAttributeName: shadow
                                                            }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [GeTuiSdk enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)reachabilityDicChanged:(NSNotification *)notification {
    AFNetworkReachabilityStatus status = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
        [[RequestCacher sharedInstance] reloadRequest];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDicChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    if ([UserInfo userHaveLogin]) {
        [UserInfoModel addUpUserLiveness:^(id object, NSString *msg) {
            if (!msg) {
                NSLog(@"统计成功");
            }
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)startSdkWith:(NSString *)appId appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    NSError *error = nil;
    [GeTuiSdk startSdkWithAppId:appId appKey:appKey appSecret:appSecret delegate:self error:&error];
    [GeTuiSdk runBackgroundEnable:YES];
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    if (error) {
        NSLog(@"设置个推失败");
    }
}

#pragma mark - GeTui Delegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //注册成功，返回clientId
//    [UserInfoModel updateDeviceToken:clientId handler:^(id object, NSString *msg) {
//        if (msg) {
//            NSLog(@"update device token failed %@", msg);
//        }
//    }];
}
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId {
    //收到个推消息
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId]; //根据payloadId取回Payload
    
    NSString *payloadMsg = nil;
    
    if (payload) {
        
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                      
                                              length:payload.length
                      
                                            encoding:NSUTF8StringEncoding];
        
        
    }
    
    //NSString *record = [NSString stringWithFormat:@"%d, %@, %@",++_lastPaylodIndex, [self formateTime:[NSDate date]], payloadMsg];
}
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    //发送上行消息结果反馈
}
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告
}
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    //通知sdk运行状态
}

/*
 微信回调
 */
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *chatResponse = (SendAuthResp *)resp;
        if (chatResponse.errCode == 0) {
            _code = chatResponse.code;
            [self getAccess];
        }
    }
}

- (void)onReq:(BaseReq *)req {
}

- (void)getAccess {
    [UserInfoModel getWeChatAccessToken:_code handler:^(id object, NSString *msg) {
        _openID = [object objectForKey:@"openid"];
        _accessToken = [object objectForKey:@"access_token"];
        [self getWeChatUserInfo];
    }];
}

- (void)getWeChatUserInfo {
    [UserInfoModel getWeChatUserInfo:_openID token:_accessToken handler:^(id object, NSString *msg) {
        _nickname = [object objectForKey:@"nickname"];
        _headportrait = [object objectForKey:@"headimgurl"];
        _sex = [object objectForKey:@"sex"];
        _unionid = [object objectForKey:@"unionid"];
        [self weChatLogin];
    }];
}

- (void)weChatLogin {
    [UserInfoModel weChatLogin:_unionid handler:^(id object, NSString *msg) {
        if (msg) {
            RBBlockAlertView *alert =[[RBBlockAlertView alloc] initWithTitle:@"提示" message:@"登录失败" block:^(NSInteger buttonIndex) {
            } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else {
            if ([object[@"state"] integerValue] == 1000) {
                NSLog(@"登录成功");
                [self saveUserInfo:object[@"data"]];
                [self initPush];
            } else if ([object[@"state"] integerValue] == 1003) {
                NSLog(@"还没注册");
                [self weChatRegister];
                
            } else {
                NSLog(@"登录失败");
            }
        }
    }];
}

- (void)weChatRegister {
    NSDictionary *dic = @{@"unionid" : _unionid,
                          @"nickname" : _nickname,
                          @"sex" : _sex,
                          @"headportrait" : _headportrait};
    [UserInfoModel weChatRegister:dic handler:^(id object, NSString *msg) {
        if (msg) {
            RBBlockAlertView *alert =[[RBBlockAlertView alloc] initWithTitle:@"提示" message:@"注册失败" block:^(NSInteger buttonIndex) {
            } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else {
            [self saveUserInfo:object];
        }
    }];
}

- (void)saveUserInfo:(NSDictionary *)dic {
    if ([Util isEmpty:dic]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginFail object:@YES];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"userid"] forKey:UserIdKey];
//        [Answers logCustomEventWithName:@"Save User Info"
//                       customAttributes:@{@"UserToken" :dic[@"usertoken"]}];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"usertoken"] forKey:UserTokenKey];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"nickname"] forKey:UserName];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"userheadportrait"] forKey:UserHeadportrait];
        [[NSUserDefaults standardUserDefaults] setValue:_sex forKey:UserSex];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"isNewUser"] forKey:IsNewUserKey];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IsFirstOpenTool];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IsFirstOpenVideo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginStateChange object:@YES];
    }
}

- (void)shareWithWeChatFriends:(NSString *)title Description:(NSString *)description Url:(NSString *)urlString Photo:(NSString *)photoUrl {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    //[message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]]]];
    [message setThumbImage:[UIImage imageNamed:photoUrl]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
- (void)shareToWechat:(NSString *)title Description:(NSString *)description Url:(NSString *)urlString Photo:(NSString *)photoUrl {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]]]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}
- (void)checkUpdate {
    [UserInfoModel checkUpdate:^(id object, NSString *msg) {
        if (object) {
            if ([object[@"version"] integerValue] == 2) {
                NSString *updateString = object[@"updateurl"];
                [[[RBBlockAlertView alloc] initWithTitle:@"有新版本更新" message:object[@"data"] block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateString]];
                    }
                } cancelButtonTitle:@"暂不更新" otherButtonTitles:@"马上更新", nil] show];
            }
        }
    }];
}

@end
