//
//  FetchCourseMemberRequest.m
//  fitplus
//
//  Created by xlp on 15/9/29.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "FetchCourseMemberRequest.h"

@implementation FetchCourseMemberRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"courseId" : _courseId} mutableCopy];
    if (_limit != 0) {
        [param setObject:@(_limit) forKey:@"indexParam"];
    } else {
        [param setObject:@(0) forKey:@"indexParam"];
    }
    [[RequestManager sharedNewInstance] POST:@"fit-port-normal/course/selectUserList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
