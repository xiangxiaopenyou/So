//
//  CourseDetailModel.m
//  fitplus
//
//  Created by xlp on 15/9/28.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "CourseDetailModel.h"
#import "CourseDetailRequest.h"
#import "JoinCourseRequest.h"
@implementation CourseDetailModel
+ (void)fetchCourseDetailWith:(NSString *)courseId handler:(RequestResultHandler)handler {
    [[CourseDetailRequest new] request:^BOOL(CourseDetailRequest *request) {
        request.courseId = courseId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            CourseDetailModel *detailModel= [[CourseDetailModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(detailModel, nil);
        }
    }];
}
+ (void)joinCourseWith:(NSString *)courseId dayId:(NSString *)dayId handler:(RequestResultHandler)handler {
    [[JoinCourseRequest new] request:^BOOL(JoinCourseRequest *request) {
        request.courseId = courseId;
        request.dayIdString = dayId;
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
