//
//  RecordCell.h
//  fitplus
//
//  Created by xlp on 15/8/19.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockInInforModel.h"

@interface RecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UIImageView *clockInTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *clockInEnergyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *energyLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *energyLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopConstraint;

- (void)setupContentWithModel:(ClockInInforModel *)infoModel;
- (CGFloat)heightForCell:(ClockInInforModel *)infoModel;

@end
