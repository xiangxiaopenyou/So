//
//  HomePageTableViewCell.h
//  fitplus
//
//  Created by 陈 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumeImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UIImageView *clockInImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
