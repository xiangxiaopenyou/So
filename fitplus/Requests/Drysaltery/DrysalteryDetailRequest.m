//
//  DrysalteryDetailRequest.m
//  fitplus
//
//  Created by xlp on 15/8/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DrysalteryDetailRequest.h"

@implementation DrysalteryDetailRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] stringForKey:UserTokenKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"userToken" : usertoken,
                                    @"articleId" : _dryId} mutableCopy];
    [[RequestManager sharedNewInstance] POST:@"fit-port-normal/article/articleDatails" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"resultCode"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"resultMsg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
