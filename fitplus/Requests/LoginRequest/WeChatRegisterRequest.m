//
//  WeChatRegisterRequest.m
//  fitplus
//
//  Created by xlp on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "WeChatRegisterRequest.h"

@implementation WeChatRegisterRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSDictionary *param = @{@"openid" : _openid,
                            @"nickname" : _nickname,
                            @"headimgurl" : _headportrait,
                            @"sex" : _sex,
                            @"systemType" : _systemType};
    param = [[RBRequest new] buildParam:param];
    [[RequestManager sharedInstance] POST:@"Own/thirdRegister" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}

@end
