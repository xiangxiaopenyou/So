//
//  ClockInRecordModel.h
//  fitplus
//
//  Created by 天池邵 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"
#import "PhotoTagModel.h"
#import "ClockInGoodModel.h"
@interface ClockInRecordModel : BaseModel
@property (copy, nonatomic) NSArray<ClockInGoodModel> *goods;
@property (assign, nonatomic) CGFloat calories;
@property (copy, nonatomic) NSArray<PhotoTagModel> *tags;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *content;
@end
