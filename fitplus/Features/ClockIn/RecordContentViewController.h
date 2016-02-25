//
//  RecordContentViewController.h
//  fitplus
//
//  Created by 天池邵 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockInCommons.h"

@interface RecordContentViewController : UIViewController
@property (copy, nonatomic) NSArray *selectedGoods;
@property (copy, nonatomic) NSString *calories;
@property (assign, nonatomic) ClockInType type;
@end
