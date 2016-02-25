//
//  FetchRecommendedCourseRequest.m
//  fitplus
//
//  Created by xlp on 15/9/22.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "FetchRecommendedCourseRequest.h"

@implementation FetchRecommendedCourseRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"page" : @(_page)} mutableCopy];
    [[RequestManager sharedNewInstance] POST:@"fit-port-normal/course/courseRecommendList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"resultCode"] integerValue] == 1000) {
            //NSLog(@"%@", responseObject);
            !resultHandler ?: resultHandler(responseObject[@"resultMap"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"resultMsg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
