//
//  FriendsClockInRequest.m
//  fitplus
//
//  Created by xlp on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FriendsClockInRequest.h"

@implementation FriendsClockInRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] stringForKey:UserTokenKey];
    if (!userid || !usertoken) {
        return;
    }
    NSMutableDictionary *param = [@{@"userid" : userid,
                                   @"usertoken" :usertoken
                                   } mutableCopy];
    if (_limit != 0) {
        [param setObject:@(_limit) forKey:@"limit"];
    }
    [[RequestManager sharedInstance] POST:@"Trends/trendsFansList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject, nil);
        }
        else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}

@end
