//
//  AddAtentionRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AddAttentionRequest.h"
#import "CommonsDefines.h"
@implementation AddAttentionRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    if (userid && usertoken && _friendid) {
        NSDictionary *param = @{@"userid" : userid,
                                @"usertoken" : usertoken,
                                @"frendid" : _friendid};
        [[RequestManager sharedInstance] POST:@"Own/fansAdd" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1000) {
                !resultHandler ?: resultHandler(responseObject[@"message"], nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            !resultHandler ?: resultHandler(nil, [self handlerError:error]);
        }];
    } else {
        !resultHandler ?: resultHandler(nil, @"关注失败");
    }
}

@end
