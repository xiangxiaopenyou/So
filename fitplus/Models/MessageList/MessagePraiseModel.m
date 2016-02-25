//
//  MessagePraiseModel.m
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessagePraiseModel.h"
#import "MessagePraiseRequest.h"
#import "LimitResultModel.h"

@implementation MessagePraiseModel

+ (void)MessagePraiseWithLimit:(NSInteger)limit handler:(RequestResultHandler)handler{
    [[MessagePraiseRequest new] request:^BOOL(MessagePraiseRequest *request) {
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        }else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[MessagePraiseModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}


@end
