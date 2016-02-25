//
//  RequestManager.h
//  RainbowKit
//
//  Created by Shao.Tc on 15/4/22.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
extern NSString *const BaseApiURL;
extern NSString *const NewBaseApiURL;
extern NSString *const WechatTokenUrl;
extern NSString *const BaseApiURL2;
extern NSString *const BaseImageURL;

@interface RequestManager : AFHTTPSessionManager
+ (instancetype)sharedInstance;
+ (instancetype)sharedNewInstance;
+ (instancetype)sharedWXInstance;

@end
