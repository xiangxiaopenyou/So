//
//  CourseTrendModel.h
//  fitplus
//
//  Created by xlp on 15/9/29.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface CourseTrendModel : BaseModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString<Optional> *nickname;
@property (copy, nonatomic) NSString *courseid;
@property (assign, nonatomic) NSInteger courseday;
@property (assign, nonatomic) NSInteger calorie;
@property (copy, nonatomic) NSString *createdate;
@property (copy, nonatomic) NSString<Optional> *portrait;
@property (copy, nonatomic) NSString *coursename;

+ (void)fetchCourseTrends:(NSString *)courseId limit:(NSInteger)limit handler:(RequestResultHandler)handler;
+ (void)fetchCourseMember:(NSString *)courseId limit:(NSInteger)limit handler:(RequestResultHandler)handler;

@end
