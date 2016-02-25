//
//  CourseCell.h
//  fitplus
//
//  Created by xlp on 15/9/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@interface CourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDifficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseMemberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *joinImage;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

- (void)setupContent:(CourseModel *)model;


@end
