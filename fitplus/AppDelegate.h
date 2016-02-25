//
//  AppDelegate.h
//  fitplus
//
//  Created by 天池邵 on 15/6/25.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "GeTuiSdk.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) shareWithWeChatFriends:(NSString*)title Description:(NSString*)description Url:(NSString*)urlString Photo:(NSString*)photoUrl;
- (void) shareToWechat:(NSString*)title Description:(NSString*)description Url:(NSString*)urlString Photo:(NSString*)photoUrl;


@end

