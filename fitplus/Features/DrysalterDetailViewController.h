//
//  DrysalterDetailViewController.h
//  fitplus
//
//  Created by 陈 on 15/8/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrysalteryModel.h"

@interface DrysalterDetailViewController : UIViewController
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *playerUrl;
@property (nonatomic, copy) NSString *drysalteryId;
@property (copy, nonatomic) DrysalteryModel *model;
@end
