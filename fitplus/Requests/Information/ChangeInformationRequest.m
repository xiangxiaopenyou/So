//
//  ChangeInformationRequest.m
//  fitplus
//
//  Created by 陈 on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChangeInformationRequest.h"
#import "CommonsDefines.h"
#import "QNImageUploadRequest.h"

@implementation ChangeInformationRequest

- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    [[QNImageUploadRequest new] request:^BOOL(QNImageUploadRequest *request) {
        request.images = @[_portrait];
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !resultHandler ?: resultHandler(nil, msg);
        } else {
            NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UserIdKey];
            NSString *usertoken = [[NSUserDefaults standardUserDefaults] valueForKey:UserTokenKey];
            NSMutableDictionary *param = [@{@"userid" : userid,
                                    @"usertoken" : usertoken,
                                    @"nickname" : _nickname,
                                    @"weightT" : _weightT,
                                    @"weight" :_weight,
                                    @"sex" :_sex,
                                    @"duration" : _duration,
                                    @"portrait" : object[0],
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
    }];
    
}

@end
