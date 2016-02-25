//
//  informationImageModel.m
//  fitplus
//
//  Created by 陈 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "informationImageModel.h"
#import "InformationImageRequest.h"
#import "LimitResultModel.h"

@implementation informationImageModel
+ (void)getInfoImageWithFrendid:(NSString *)frendid WithLimit:(NSInteger)limit handler:(RequestResultHandler)handler{
    [[InformationImageRequest new] request:^BOOL(InformationImageRequest *request) {
        request.frendid = frendid;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[informationImageModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}
@end
