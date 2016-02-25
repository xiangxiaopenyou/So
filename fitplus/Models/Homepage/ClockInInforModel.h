//
//  HomepageModel.h
//  fitplus
//
//  Created by 陈 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface ClockInInforModel : BaseModel
@property (nonatomic, strong) NSString *count_day;
@property (nonatomic, strong) NSString *created_time;
@property (nonatomic, strong) NSString *food_num;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *ispublic;
@property (nonatomic, strong) NSString *palycard_tag;
@property (nonatomic, strong) NSString *playcard_food;
@property (nonatomic, strong) NSString *playcard_sport;
@property (nonatomic, strong) NSString *sport_num;
@property (nonatomic, strong) NSString *trendcontent;
@property (nonatomic, strong) NSString *trendpicture;
@property (nonatomic, strong) NSString *trendsportstype;
@property (nonatomic, strong) NSString *userid;

+ (void)getclockMessgeWithFrendid:(NSString *)frendid WithLimit:(NSInteger)limit handler:(RequestResultHandler)handler;
@end
