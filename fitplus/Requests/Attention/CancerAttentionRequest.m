//
//  CancerAttentionRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CancerAttentionRequest.h"
#import "CommonsDefines.h"

@implementation CancerAttentionRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    //    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    //    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    NSDictionary *param = @{@"userid" : @"16",
                            @"usertoken" : @"z9cdgq8wnqy62cn8zb0lec0d784ow2k2ky0uk9ij6ny2000w18c65b89d8780f344359a1b5df93ad1c",
                            @"frendid" : _frindeid};
    [[RequestManager sharedInstance] POST:@"Own/fansDel" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject[@"message"], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}


@end
