//
//  UserCourseTrendModel.h
//  fitplus
//
//  Created by xlp on 15/10/23.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface UserCourseTrendModel : BaseModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString<Optional> *nickname;
@property (copy, nonatomic) NSString *courseId;
@property (assign, nonatomic) NSInteger courseDay;
@property (assign, nonatomic) NSInteger calorie;
@property (copy, nonatomic) NSString *createDate;
@property (copy, nonatomic) NSString<Optional> *portrait;
@property (copy, nonatomic) NSString *courseName;

+ (void)fetchMyCourseTrends:(NSInteger)page handler:(RequestResultHandler)handler;
+ (void)fetchUserCourseTrends:(NSInteger)page otherId:(NSString *)otherId handler:(RequestResultHandler)handler;

@end
