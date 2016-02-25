//
//  InformationImageRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "InformationImageRequest.h"
#import "CommonsDefines.h"

@implementation InformationImageRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
    NSMutableDictionary *parm = [@{@"userid" : userid,
                                   @"usertoken" : usertoken,
                                   } mutableCopy];
    if (_frendid && ![_frendid isEqualToString:@""]) {
        [parm setObject:_frendid forKey:@"frendid"];
    }
    if (_limit &&! _limit == 0) {
        [parm setObject:@(_limit) forKey:@"limit"];
    }
    [[RequestManager sharedInstance] POST:@"Trends/trendsPicture" parameters:[self buildParam:parm] success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1000) {
                !resultHandler ?: resultHandler(responseObject, nil);
            }else {
                !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            !resultHandler ?: resultHandler(nil, [self handlerError:error]);
        }];
    
}
@end
