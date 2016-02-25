//
//  LabelModel.m
//  fitplus
//
//  Created by xlp on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "LabelModel.h"
#import "FetchLagRequest.h"
#import "LimitResultModel.h"

@implementation LabelModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"labelId",
                                                       @"name" : @"labelName"
                                                       }];
}
+ (void)fetchLabelListWith:(NSString *)like limit:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FetchLagRequest new] request:^BOOL(FetchLagRequest *request) {
        request.like = like;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[LabelModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}

@end
