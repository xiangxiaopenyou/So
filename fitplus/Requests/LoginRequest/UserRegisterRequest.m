//
//  UserRegisterRequest.m
//  fitplus
//
//  Created by xlp on 15/7/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UserRegisterRequest.h"

@implementation UserRegisterRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSMutableDictionary *param = [@{@"nickname" : _nickname,
                                    @"password" : _password,
                                    @"systemType" : @"ios"} mutableCopy];
    [[RequestManager sharedInstance] POST:@"Own/register" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
