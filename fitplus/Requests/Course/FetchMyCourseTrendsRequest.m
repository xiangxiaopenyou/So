//
//  FetchMyCourseTrendsRequest.m
//  fitplus
//
//  Created by xlp on 15/10/23.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "FetchMyCourseTrendsRequest.h"

@implementation FetchMyCourseTrendsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"page" : @(_page)} mutableCopy];
    [[RequestManager sharedInstance] POST:@"Course/selectCourseNewsMyList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
