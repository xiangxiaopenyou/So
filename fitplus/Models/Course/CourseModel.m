//
//  CourseModel.m
//  fitplus
//
//  Created by xlp on 15/9/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseModel.h"
#import "FetchMyCourseRequest.h"
#import "FetchMoreCourseRequest.h"
#import "FetchRecommendedCourseRequest.h"
#import "LimitResultModel.h"
#import "FetchMyEnergyDataRequest.h"
#import "FinishDayCourseReqeust.h"
#import "ExitCourseRequest.h"

@implementation CourseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"courseId",
                                                       @"subject_name" : @"courseName",
                                                       @"traning_day" : @"courseDays",
                                                       @"traning_model" : @"courseModel",
                                                       @"traning_site" : @"courseBody",
                                                       @"savepath" : @"coursePicture",
                                                       @"traning_difficult" : @"courseDifficulty",
                                                       @"num" : @"courseMember",
                                                       @"involved" : @"isJoin"}];
}
+ (void)fetchMoreCourse:(NSInteger)page difficulty:(NSInteger)trainingDifficuty model:(NSInteger)trainingModel site:(NSString *)trainingSite handler:(RequestResultHandler)handler {
    [[FetchMoreCourseRequest new] request:^BOOL(FetchMoreCourseRequest *request) {
        request.page = page;
        request.courseDifficulty = trainingDifficuty;
        request.courseModel = trainingModel;
        request.courseSite = trainingSite;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *tempModel = [[LimitResultModel alloc] initWithNewResult:object modelKey:@"list" modelClass:[CourseModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchMyCourse:(NSInteger)page handler:(RequestResultHandler)handler {
    [[FetchMyCourseRequest new] request:^BOOL(FetchMyCourseRequest *request) {
        request.page = page;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *tempModel = [[LimitResultModel alloc] initWithNewResult:object modelKey:@"list" modelClass:[CourseModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchRecommendedCourse:(NSInteger)page handler:(RequestResultHandler)handler {
    [[FetchRecommendedCourseRequest new] request:^BOOL(FetchRecommendedCourseRequest *request) {
        request.page = page;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *tempModel = [[LimitResultModel alloc] initWithNewResult:object modelKey:@"courseData" modelClass:[CourseModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchMyData:(RequestResultHandler)handler {
    [[FetchMyEnergyDataRequest new] request:^BOOL(FetchMyEnergyDataRequest *request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        } 
    }];
}
+ (void)finishDayCourse:(NSDictionary *)dictionary handler:(RequestResultHandler)handler {
    [[FinishDayCourseReqeust new] request:^BOOL(FinishDayCourseReqeust *request) {
        request.informationDic = dictionary;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)exitCourse:(NSString *)courseId handler:(RequestResultHandler)handler {
    [[ExitCourseRequest new] request:^BOOL(ExitCourseRequest *request) {
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
