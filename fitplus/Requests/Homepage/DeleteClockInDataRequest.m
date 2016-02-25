//
//  DeleteClockInDataRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DeleteClockInDataRequest.h"
#import "CommonsDefines.h"
@implementation DeleteClockInDataRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    NSDictionary *param = @{@"userid" : userid,
                            @"usertoken" : usertoken,
                            @"trendid" : _trendid};
    [[RequestManager sharedInstance] POST:@"Trends/trendDelete" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject[@"message"], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}

@end
