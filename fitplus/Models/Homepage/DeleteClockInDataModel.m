//
//  DeleteClockInDataModel.m
//  fitplus
//
//  Created by 陈 on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DeleteClockInDataModel.h"
#import "DeleteClockInDataRequest.h"
@implementation DeleteClockInDataModel

+ (void)deleteClockInWithTrendid:(NSString *)trendid handler:(RequestResultHandler)handler{
    [[DeleteClockInDataRequest new] request:^BOOL(DeleteClockInDataRequest *request) {
        request.trendid = trendid;
        return YES;
    } result:^(NSArray* object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];

}

@end
