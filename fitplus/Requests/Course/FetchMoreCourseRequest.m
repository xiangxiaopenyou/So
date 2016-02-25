//
//  FetchMoreCourseRequest.m
//  fitplus
//
//  Created by xlp on 15/9/22.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "FetchMoreCourseRequest.h"

@implementation FetchMoreCourseRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"page" : @(_page)} mutableCopy];
    if (_courseDifficulty > 0) {
        [param setObject:@(_courseDifficulty) forKey:@"traning_difficult"];
    }
    if (_courseModel > 0) {
        [param setObject:@(_courseModel) forKey:@"traning_model"];
    }
    if (_courseSite != nil) {
        [param setObject:_courseSite forKey:@"traning_site"];
    }
    
    [[RequestManager sharedInstance] POST:@"Course/courseList" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            // NSLog(@"%@", responseObject);
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
