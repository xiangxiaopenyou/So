//
//  FetchTagsRequest.m
//  fitplus
//
//  Created by xlp on 15/11/16.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "FetchTagsRequest.h"

@implementation FetchTagsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [[RequestManager sharedInstance] POST:@"Course/getTageInf" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
