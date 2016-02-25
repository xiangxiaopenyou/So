//
//  CourseCell.m
//  fitplus
//
//  Created by xlp on 15/9/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseCell.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"

@implementation CourseCell

- (void)setupContent:(CourseModel *)model {
    _courseNameLabel.text = model.courseName;
    switch (model.courseDifficulty) {
        case 1:{
            _courseDifficultyLabel.text = @"初级";
        }
            break;
        case 2:{
            _courseDifficultyLabel.text = @"中级";
        }
            break;
        case 3:{_courseDifficultyLabel.text = @"高级";
        }
            break;
        default:
            break;
    }
    _courseDaysLabel.text = [NSString stringWithFormat:@"%ld天", (long)model.courseDays];
    _courseBodyLabel.text = [NSString stringWithFormat:@"%@", model.courseBody];
    _courseMemberLabel.text = [NSString stringWithFormat:@"%ld人已参加", (long)model.courseMember];
    
    [_courseImageView setImageWithURL:[NSURL URLWithString:[Util urlCourseListPhoto:model.coursePicture]] placeholderImage:[UIImage imageNamed:@"default_image"]];
    if ([model.isJoin integerValue] == 0) {
        _joinImage.hidden = YES;
    } else {
        _joinImage.hidden = NO;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
