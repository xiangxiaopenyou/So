//
//  HomepageRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInInforRequest.h"
#import "CommonsDefines.h"

@implementation ClockInInforRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    if (userid && usertoken) {
        NSMutableDictionary *param = [@{@"userid" : userid,
                                        @"usertoken" : usertoken,
                                        } mutableCopy];
        if (_frendid && ![_frendid isEqualToString:@""]) {
            [param setObject:_frendid forKey:@"frendid"];
        }
        if (_limit &&! _limit == 0) {
            [param setObject:@(_limit) forKey:@"limit"];
        }
        [[RequestManager sharedInstance] POST:@"Trends/trendsList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1000) {
                !resultHandler ?: resultHandler(responseObject, nil);
            }else {
                !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            !resultHandler ?: resultHandler(nil, [self handlerError:error]);
        }];

    } else {
        !resultHandler ?: resultHandler(nil, @"请求失败");
    }
}
@end
