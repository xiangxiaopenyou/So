//
//  GetOwnInfomationRequest.m
//  fitplus
//
//  Created by xlp on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "GetOwnInfomationRequest.h"

@implementation GetOwnInfomationRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    NSMutableDictionary *param = [@{@"userid" : userid,
                                   @"usertoken" : usertoken,
                                   } mutableCopy];
    [[RequestManager sharedInstance] POST:@"Own/findTerminal" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
