//
//  ClockInRecordRequest.m
//  fitplus
//
//  Created by 天池邵 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInRecordRequest.h"

@implementation ClockInRecordRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] stringForKey:UserTokenKey];
    NSData *recordsData = [NSJSONSerialization dataWithJSONObject:_records options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonRecords = [[NSString alloc] initWithData:recordsData encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"userid" : userid,
                            @"usertoken" : usertoken,
                            @"strdata" : jsonRecords};
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        [self cacheRequest:@"Trends/trendsAdd" method:@"POST" param:[self buildParam:param]];
        !resultHandler ?: resultHandler(@"请求已经缓存", @"请求已经缓存");
        return;
    }
    
    [[RequestManager sharedInstance] POST:@"Trends/trendsAdd" parameters:[self buildParam:param] success:^(NSURLSessionDataTask *task, id responseObject) {
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
