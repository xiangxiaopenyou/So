//
//  UserCourseTrendModel.m
//  fitplus
//
//  Created by xlp on 15/10/23.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "UserCourseTrendModel.h"
#import "FetchMyCourseTrendsRequest.h"
#import "LimitResultModel.h"
#import "FetchUserTrendsRequest.h"

@implementation UserCourseTrendModel
+ (void)fetchMyCourseTrends:(NSInteger)page handler:(RequestResultHandler)handler {
    [[FetchMyCourseTrendsRequest new] request:^BOOL(FetchMyCourseTrendsRequest *request) {
        request.page = page;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *tempModel = [[LimitResultModel alloc] initWithNewResult:object modelKey:@"list" modelClass:[UserCourseTrendModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchUserCourseTrends:(NSInteger)page otherId:(NSString *)otherId handler:(RequestResultHandler)handler {
    [[FetchUserTrendsRequest new] request:^BOOL(FetchUserTrendsRequest *request) {
        request.otherId = otherId;
        request.page = page;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *tempModel = [[LimitResultModel alloc] initWithNewResult:object modelKey:@"list" modelClass:[UserCourseTrendModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}

@end
