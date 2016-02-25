//
//  CalorieDataModel.h
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface CalorieDataModel : BaseModel
@property (assign, nonatomic) NSInteger consume;
@property (assign, nonatomic) NSInteger food_num;
@property (assign, nonatomic) NSInteger sport_num;
@property (assign, nonatomic) NSInteger walks_num;
@property (assign, nonatomic) NSInteger kilometers_num;
@property (copy, nonatomic) NSString *percentage;
@property (assign, nonatomic) NSInteger age;
+ (void)fetchCalorieData:(NSInteger)friendid day:(NSString *)day handler:(RequestResultHandler)handler;

+ (void)uploadStepDatas:(NSArray *)stepDatas handler:(RequestResultHandler)handler;
@end
