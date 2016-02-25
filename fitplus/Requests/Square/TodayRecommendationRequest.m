//
//  TodayRecommendationRequest.m
//  fitplus
//
//  Created by xlp on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TodayRecommendationRequest.h"

@implementation TodayRecommendationRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] stringForKey:UserTokenKey];
    NSMutableDictionary *param = [@{@"userid" : userid,
                                    @"usertoken" : usertoken
                                    } mutableCopy];
    if (_limit != 0) {
        [param setObject:@(_limit) forKey:@"limit"];
    }
    [[RequestManager sharedInstance] POST:@"GroomTrend/groomTrendsList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
