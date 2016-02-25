//
//  GuideRequest.m
//  fitplus
//
//  Created by xlp on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "GuideRequest.h"

@implementation GuideRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    NSDictionary *param = @{@"userid" : userid,
                            @"usertoken" : usertoken,
                            @"height" : _height,
                            @"weight" : _weight,
                            @"weightT" : @"66",
                            @"sex" : _sex,
                            @"duration" : @"1",
                            @"birthday" : _age};
    [[RequestManager sharedInstance] POST:@"Own/guide" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}

@end
