//
//  CancelAttentionRequest.m
//  fitplus
//
//  Created by xlp on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CancelAttentionRequest.h"

@implementation CancelAttentionRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    if (userid && usertoken && _friendId) {
        NSDictionary *param = @{@"userid" : userid,
                                @"usertoken" : usertoken,
                                @"frendid" : _friendId};
        [[RequestManager sharedInstance] POST:@"Own/fansDel" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1000) {
                !resultHandler ?: resultHandler(responseObject[@"message"], nil);
            } else {
                !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            !resultHandler ?: resultHandler(nil, [self handlerError:error]);
        }];
    } else {
        !resultHandler ?: resultHandler(nil, @"取消关注失败");
    }
}

@end
