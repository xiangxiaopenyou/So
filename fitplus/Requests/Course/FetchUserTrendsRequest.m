//
//  FetchUserTrendsRequest.m
//  fitplus
//
//  Created by xlp on 15/10/28.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "FetchUserTrendsRequest.h"

@implementation FetchUserTrendsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSMutableDictionary *param = [@{@"userId" : userid,
                                    @"OtherId" : _otherId,
                                    @"page" : @(_page)} mutableCopy];
    [[RequestManager sharedInstance] POST:@"Order/getOtherInf" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
