//
//  BackHomeRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "InformationRequest.h"
#import "CommonsDefines.h"

@implementation InformationRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];

    NSMutableDictionary *param = [@{@"userid" : userid,
                                   @"usertoken" : usertoken,
                                   } mutableCopy];
    if (_frendid && ![_frendid isEqualToString:@""]) {
        [param setObject:_frendid forKey:@"frendid"];
    }
    [[RequestManager sharedInstance] POST:@"Trends/trendsTerminal" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
