
//
//  DrysalteryCommentListRequest.m
//  fitplus
//
//  Created by xlp on 15/8/11.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DrysalteryCommentListRequest.h"

@implementation DrysalteryCommentListRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] stringForKey:UserTokenKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"userToken" : usertoken,
                                    @"articleId" : _articleId} mutableCopy];
    if (_limit != 0) {
        [param setObject:@(_limit) forKey:@"indexParam"];
    } else {
        [param setObject:@(0) forKey:@"indexParam"];
    }
    [[RequestManager sharedNewInstance] POST:@"fit-port-normal/article/articleComentList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"resultCode"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject[@"resultMap"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"resultMsg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}
@end
