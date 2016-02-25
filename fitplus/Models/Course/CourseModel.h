//
//  CourseModel.h
//  fitplus
//
//  Created by xlp on 15/9/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface CourseModel : BaseModel
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *courseName;
@property (nonatomic, assign) NSInteger courseDifficulty;
@property (nonatomic, assign) NSInteger courseDays;
@property (nonatomic, copy) NSString *courseBody;
@property (nonatomic, assign) NSInteger courseMember;
@property (nonatomic, assign) NSInteger courseModel;
@property (nonatomic, copy) NSString *coursePicture;
@property (nonatomic, copy) NSString<Optional> *isJoin;
@property (nonatomic, assign) NSInteger total_calories;
@property (nonatomic, assign) NSInteger total_activity;
@property (nonatomic, assign) NSInteger total_time;
@property (nonatomic, copy) NSString<Optional> *couserDayEnNum;
@property (nonatomic, copy) NSString<Optional> *caloriesNum;
@property (nonatomic, copy) NSString<Optional> *desc;

+ (void)fetchMyCourse:(NSInteger)page handler:(RequestResultHandler)handler;
+ (void)fetchRecommendedCourse:(NSInteger)page handler:(RequestResultHandler)handler;
+ (void)fetchMoreCourse:(NSInteger)page difficulty:(NSInteger)trainingDifficuty model:(NSInteger)trainingModel site:(NSString *)trainingSite handler:(RequestResultHandler)handler;
+ (void)fetchMyData:(RequestResultHandler)handler;
+ (void)finishDayCourse:(NSDictionary *)dictionary handler:(RequestResultHandler)handler;
+ (void)exitCourse:(NSString *)courseId handler:(RequestResultHandler)handler;
@end
