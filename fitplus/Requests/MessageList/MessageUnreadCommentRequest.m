//
//  MessageListRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessageUnreadCommentRequest.h"
#import "CommonsDefines.h"

@implementation MessageUnreadCommentRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    if (usertoken && userid) {
        NSDictionary *param = @{@"userid" : userid,
                                @"usertoken" : usertoken};
        [[RequestManager sharedInstance] POST:@"News/newsNum" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1000) {
                !resultHandler ?: resultHandler(responseObject[@"data"], nil);
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
