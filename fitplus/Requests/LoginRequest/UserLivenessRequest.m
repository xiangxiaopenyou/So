//
//  UserLivenessRequest.m
//  fitplus
//
//  Created by xlp on 15/9/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UserLivenessRequest.h"

@implementation UserLivenessRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] stringForKey:UserTokenKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"userToken" : usertoken} mutableCopy];
    [[RequestManager sharedNewInstance] POST:@"fit-port-user/userStatistics/updateLoginSum" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        !resultHandler ?: resultHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
