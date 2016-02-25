//
//  SubmitInfomationRequest.m
//  fitplus
//
//  Created by xlp on 15/11/16.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "SubmitInfomationRequest.h"

@implementation SubmitInfomationRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"sex" : _dictionary[@"sex"],
                                    @"height" : _dictionary[@"height"],
                                    @"weight" : _dictionary[@"weight"],
                                    @"tag" : _dictionary[@"tag"],
                                    @"body" : _dictionary[@"body"],
                                    @"SportTime" : _dictionary[@"sporttime"]} mutableCopy];
    [[RequestManager sharedInstance] POST:@"Course/guide" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
