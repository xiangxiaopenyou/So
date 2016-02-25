//
//  ChangeInforNoImageRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChangeInforNoImageRequest.h"

@implementation ChangeInforNoImageRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    NSMutableDictionary *param = [@{@"userid" : userid,
                                    @"usertoken" : usertoken,
                                    @"nickname" : _nickname,
                                    @"weightT" : _weightT,
                                    @"weight" :_weight,
                                    @"sex" :_sex,
                                    @"duration" : _duration,
                                    @"portrait" : _portrait,
                                    @"introduce" : _introduce,
                                    @"height" : _height
                                    } mutableCopy];
    [[RequestManager sharedInstance] POST:@"Own/updateTerminal" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
