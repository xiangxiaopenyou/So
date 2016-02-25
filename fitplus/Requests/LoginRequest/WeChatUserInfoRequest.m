//
//  WeChatUserInfoRequest.m
//  fitplus
//
//  Created by xlp on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "WeChatUserInfoRequest.h"
#import "CommonsDefines.h"

@implementation WeChatUserInfoRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSDictionary *param = @{@"openid" : _openid,
                            @"access_token" : _accessToken};
    [[RequestManager sharedWXInstance] GET:wxUserInfo parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        !resultHandler ?: resultHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}

@end
