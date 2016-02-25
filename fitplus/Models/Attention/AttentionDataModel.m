//
//  AttentionDataModel.m
//  fitplus
//
//  Created by 陈 on 15/7/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AttentionDataModel.h"
#import "AttentionRequest.h"
#import "LimitResultModel.h"

@implementation AttentionDataModel
+ (void)getAttentionDataWithFrendid:(NSString *)frendid WithLimit:(NSInteger)limit handler:(RequestResultHandler)handler{
    [[AttentionRequest new] request:^BOOL(AttentionRequest *request) {
        request.frendid = frendid;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        }else{
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[AttentionDataModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}

@end
