//
//  WeChatAccessRequest.m
//  fitplus
//
//  Created by xlp on 15/6/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "WeChatAccessRequest.h"
#import "CommonsDefines.h"

@implementation WeChatAccessRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSMutableDictionary *param = [@{@"appid" : wxAppKey,
                            @"secret" : wxAppSecretKey,
                            @"code" : _code,
                            @"grant_type" : @"authorization_code"} mutableCopy];
    [[RequestManager sharedWXInstance] GET:wxUserInfoAccess parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        !resultHandler ?: resultHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}

@end
