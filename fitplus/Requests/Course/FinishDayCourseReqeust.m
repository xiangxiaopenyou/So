//
//  FinishDayCourseReqeust.m
//  fitplus
//
//  Created by xlp on 15/10/10.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "FinishDayCourseReqeust.h"

@implementation FinishDayCourseReqeust
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"courseId" : _informationDic[@"courseId"],
                                    @"courseDayId" : _informationDic[@"courseDayId"],
                                    @"courseDay" : _informationDic[@"courseDay"],
                                    @"calorie" : _informationDic[@"calorie"],
                                    @"courseName" : _informationDic[@"courseName"],
                                    @"difficulty" : _informationDic[@"difficulty"],
                                    @"period" : _informationDic[@"period"]} mutableCopy];
    [[RequestManager sharedInstance] POST:@"Course/upCourse" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
