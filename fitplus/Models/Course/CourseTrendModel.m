//
//  CourseTrendModel.m
//  fitplus
//
//  Created by xlp on 15/9/29.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "CourseTrendModel.h"
#import "FetchCourseFriendsTrendsRequest.h"
#import "LimitResultModel.h"
#import "FetchCourseMemberRequest.h"
#import "FetchMyCourseTrendsRequest.h"

@implementation CourseTrendModel
+ (void)fetchCourseTrends:(NSString *)courseId limit:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FetchCourseFriendsTrendsRequest new] request:^BOOL(FetchCourseFriendsTrendsRequest *request) {
        request.limit = limit;
        request.courseId = courseId;
        return YES;
        
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"userList" modelClass:[CourseTrendModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}
+ (void)fetchCourseMember:(NSString *)courseId limit:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FetchCourseMemberRequest new] request:^BOOL(FetchCourseMemberRequest *request) {
        request.limit = limit;
        request.courseId = courseId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}

@end
