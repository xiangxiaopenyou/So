//
//  FetchCalorieDataRequest.m
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FetchCalorieDataRequest.h"

@implementation FetchCalorieDataRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    NSMutableDictionary *parm = [@{@"userid" : userid,
                                   @"usertoken" : usertoken,
                                   } mutableCopy];
    if (_friendId != 0) {
        [parm setObject:@(_friendId) forKey:@"frendid"];
    }
    
    if (_day && ![_day isEqualToString:@""]) {
        [parm setObject:_day forKey:@"day"];
    }
    
    [[RequestManager sharedInstance] POST:@"Trends/trendsFSConsume" parameters:[self buildParam:parm] success:^(NSURLSessionDataTask *task, id responseObject) {
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
