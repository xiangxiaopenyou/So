//
//  CheckUpdateRequest.m
//  fitplus
//
//  Created by xlp on 15/7/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CheckUpdateRequest.h"
#import "CommonsDefines.h"

@implementation CheckUpdateRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSMutableDictionary *param = [@{@"version" : kAppVersion,
                                    } mutableCopy];
    if (IsAppStore == 1) {
        [param setObject:@"1" forKey:@"isapppstore"];
    } else {
        [param setObject:@"2" forKey:@"isappstore"];
    }
    
    [[RequestManager sharedInstance] POST:@"Config/version" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}

@end
