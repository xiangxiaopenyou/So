//
//  CommonsDefines.h
//  Coach
//
//  Created by 天池邵 on 15/6/12.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const UserTokenKey;
extern NSString *const UserIdKey;
extern NSString *const UserName;
extern NSString *const UserHeadportrait;
extern NSString *const UserHeight;
extern NSString *const UserWeight;
extern NSString *const UserSex;
extern NSString *const UserBody;
extern NSString *const UserTag;
extern NSString *const UserTrainingTime;
extern NSString *const ClubIdKey;
extern NSString *const IsNewUserKey;
extern NSString *const BaseImageUrl;
extern NSString *const LogoutKey;
extern NSInteger const IsAppStore;
extern NSString *const IsFirstOpenTool;
extern NSString *const IsFirstOpenVideo;

//微信
extern NSString *const wxAppKey;
extern NSString *const wxAppSecretKey;
extern NSString *const wxDescribe;
extern NSString *const wxUserInfoAccess;
extern NSString *const wxUserInfo;

extern NSString *const CacheUsualFood;
extern NSString *const CacheUsualSport;


//接口上传固定参数
extern NSString *const appID;
extern NSString *const signMethod;
extern NSString *const LoginStateChange;
extern NSString *const LoginFail;

extern NSString *const ClockInOverNotificationKey;
extern NSString *const ClockInDeleteNotificationKey;
extern NSString *const ReceivedMessagesNotificationKey;

//分享链接
extern NSString *const DryShareUrl;
extern NSString *const CommonShareUrl;
extern NSString *const CourseShareUrl;

//个推
extern NSString *const GeTuiAppId;
extern NSString *const GeTuiAppKey;
extern NSString *const GeTuiAppSecret;


#define kCachePath(X)[NSString stringWithFormat:@"%@/Library/Caches/%@.c", NSHomeDirectory(), X]
#define kImageUrl(X) [NSString stringWithFormat:@"%@%@", BaseImageUrl, X]
#define kAttributeBlue [UIColor colorWithRed:126.0/255.0 green:158/255.0 blue:200/255.0 alpha:1]
#define kCompleteVersion [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]]
#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define SCREEN_HEIGHT UIScreen.mainScreen.bounds.size.height
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]



