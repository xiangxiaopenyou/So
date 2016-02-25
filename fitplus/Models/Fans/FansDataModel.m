//
//  FansDataModel.m
//  fitplus
//
//  Created by 陈 on 15/7/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FansDataModel.h"
#import "FansRequest.h"
#import "LimitResultModel.h"

@implementation FansDataModel
+ (void)getFansDataWithFrendid:(NSString *)frendid WithLimit:(NSInteger)limit handler:(RequestResultHandler)handler{
    [[FansRequest new] request:^BOOL(FansRequest *request) {
        request.frendid = frendid;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        }else{
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[FansDataModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}
@end
