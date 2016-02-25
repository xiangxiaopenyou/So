//
//  HomepageModel.m
//  fitplus
//
//  Created by 陈 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInInforModel.h"
#import "ClockInInforRequest.h"
#import "LimitResultModel.h"
@implementation ClockInInforModel

+(void)getclockMessgeWithFrendid:(NSString *)frendid WithLimit:(NSInteger)limit handler:(RequestResultHandler)handler{
    [[ClockInInforRequest new] request:^BOOL(ClockInInforRequest *request) {
        request.frendid = frendid;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[ClockInInforModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}
@end
