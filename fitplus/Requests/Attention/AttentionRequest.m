//
//  AttentionRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AttentionRequest.h"
#import "CommonsDefines.h"

@implementation AttentionRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    if (usertoken && userid) {
        NSMutableDictionary *param = [@{@"userid" : userid,
                                        @"usertoken" : usertoken
                                        } mutableCopy];
        if (_frendid && ![_frendid isEqual:@""]) {
            [param setObject:_frendid forKey:@"frendid"];
        }
        if (_limit && !_limit == 0) {
            [param setObject:@(_limit) forKey:@"limit"];
        }
        [[RequestManager sharedInstance] POST:@"Own/attentionList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"state"] intValue] == 1000) {
                !resultHandler ?: resultHandler(responseObject, nil);
            }else {
                !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            !resultHandler ?: resultHandler(nil, [self handlerError:error]);
        }];
    } else {
        !resultHandler ?: resultHandler(nil, @"请求数据失败");
    }
}

@end
