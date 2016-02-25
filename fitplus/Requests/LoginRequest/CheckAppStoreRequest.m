//
//  CheckAppStoreRequest.m
//  fitplus
//
//  Created by xlp on 15/7/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CheckAppStoreRequest.h"

@implementation CheckAppStoreRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [[RequestManager sharedInstance] POST:@"Config/shfind" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
