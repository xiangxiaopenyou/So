//
//  CourseDetailModel.h
//  fitplus
//
//  Created by xlp on 15/9/28.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface CourseDetailModel : BaseModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *traning_site;
@property (nonatomic, assign) NSInteger traning_day;
@property (nonatomic, assign) NSInteger traning_model;
@property (nonatomic, copy) NSString *subject_pic;
@property (nonatomic, copy) NSString *subject_name;
@property (nonatomic, copy) NSArray *day_list;
@property (nonatomic, assign) NSInteger traning_difficult;
@property (nonatomic, copy) NSDictionary *day_data;
@property (nonatomic, copy) NSString *desc;

+ (void)fetchCourseDetailWith:(NSString *)courseId handler:(RequestResultHandler)handler;
+ (void)joinCourseWith:(NSString *)courseId dayId:(NSString *)dayId handler:(RequestResultHandler)handler;

@end
