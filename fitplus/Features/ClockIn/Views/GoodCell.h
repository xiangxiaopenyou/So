//
//  FoodCell.h
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoodModel, ClockInGoodModel;

typedef void(^CalorieChangeHandler)(NSInteger value, CGFloat calorie);

@interface GoodCell : UITableViewCell
- (void)setupWithGood:(ClockInGoodModel *)good value:(NSInteger)value handler:(CalorieChangeHandler)handler;
@end
