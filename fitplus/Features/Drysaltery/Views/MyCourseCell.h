//
//  MyCourseCell.h
//  fitplus
//
//  Created by xlp on 15/9/23.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@interface MyCourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDifficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDaysLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishedDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDaysBar;
@property (weak, nonatomic) IBOutlet UILabel *finishedDaysBar;
@property (weak, nonatomic) IBOutlet UILabel *isTrainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishedDaysBarWidthConstraint;

- (void)setupContent:(CourseModel *)model;
@end
