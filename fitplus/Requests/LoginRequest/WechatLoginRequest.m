//
//  WechatLoginRequest.m
//  fitplus
//
//  Created by xlp on 15/6/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "WechatLoginRequest.h"

@implementation WechatLoginRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSMutableDictionary *param = [@{@"openid" : _openid} mutableCopy];
    [[RequestManager sharedInstance] POST:@"Own/thirdLogin" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        !resultHandler ?: resultHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}



@end
