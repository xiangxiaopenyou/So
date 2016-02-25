//
//  ClockInLikeRequest.m
//  fitplus
//
//  Created by xlp on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInLikeRequest.h"

@implementation ClockInLikeRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] stringForKey:UserTokenKey];
    NSMutableDictionary *param = [@{@"userid" : userid,
                                    @"usertoken" : usertoken,
                                    @"trendid" : _trendId} mutableCopy];
    [[RequestManager sharedInstance] POST:@"Trends/favoriteCreate" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}

@end
