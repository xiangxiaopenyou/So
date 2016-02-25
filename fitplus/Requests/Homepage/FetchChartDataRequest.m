//
//  FetchChartDataRequest.m
//  fitplus
//
//  Created by 天池邵 on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FetchChartDataRequest.h"

@implementation FetchChartDataRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    NSDictionary *param = @{@"userid" : userid,
                            @"usertoken" : usertoken,
                            @"oldday" : _oldday,
                            @"newday" : _newday};
    [[RequestManager sharedInstance] POST:@"Trends/trendsDayList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
