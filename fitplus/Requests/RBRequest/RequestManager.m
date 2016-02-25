//
//  RequestManager.m
//  RainbowKit
//
//  Created by Shao.Tc on 15/4/22.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "RequestManager.h"
#import <AFURLResponseSerialization.h>
NSString *const BaseApiURL = @"http://so.jianshen.so/Realtech/";
NSString *const NewBaseApiURL = @"http://so.jianshen.so:8080/";
//NSString *const BaseApiURL =  @"http://test.jianshen.so/Realtech/";
//NSString *const NewBaseApiURL = @"http://test.jianshen.so:8080/";
//NSString *const BaseApiURL = @"http://jianshen.so/Admin/";
//NSString *const BaseApiURL2 = @"http://192.168.2.2:5000/";

NSString *const WechatTokenUrl = @"https://api.weixin.qq.com/sns/oauth2/access_token";
// "http://jianshen.so/Admin/"

NSString *const BaseImageURL = @"http://7u2h8u.com1.z0.glb.clouddn.com/";


@implementation RequestManager
+ (instancetype)sharedInstance {
    static RequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] initWithBaseURL:[NSURL URLWithString:BaseApiURL]];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *types = [[serializer acceptableContentTypes] mutableCopy];
        [types addObjectsFromArray:@[@"text/plain", @"text/html"]];
        serializer.acceptableContentTypes = types;
        instance.responseSerializer = serializer;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 1;
    });
    return instance;
}
+ (instancetype)sharedNewInstance {
    static RequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] initWithBaseURL:[NSURL URLWithString:NewBaseApiURL]];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *types = [[serializer acceptableContentTypes] mutableCopy];
        [types addObjectsFromArray:@[@"text/plain", @"text/html"]];
        serializer.acceptableContentTypes = types;
        instance.responseSerializer = serializer;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 1;
    });
    return instance;
}

+ (instancetype)sharedWXInstance {
    static RequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] initWithBaseURL:[NSURL URLWithString:WechatTokenUrl]];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *types = [[serializer acceptableContentTypes] mutableCopy];
        [types addObjectsFromArray:@[@"text/plain", @"text/html"]];
        serializer.acceptableContentTypes = types;
        instance.responseSerializer = serializer;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 1;
    });
    return instance;
}

@end
