//
//  RecordCell.m
//  fitplus
//
//  Created by xlp on 15/8/19.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RecordCell.h"
#import "Util.h"
#import "SquareCommons.h"
#import <UIImageView+AFNetworking.h>

@implementation RecordCell
- (void)setupContentWithModel:(ClockInInforModel *)infoModel {
    CGFloat backgroundViewHeight = 0;
    if (_pointLabel.layer.cornerRadius == 0) {
        _pointLabel.layer.borderWidth = 0.5;
        _pointLabel.layer.borderColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0].CGColor;
        _pointLabel.layer.cornerRadius = 3.0;
        _pointLabel.layer.masksToBounds = YES;
    }
    UIImage *backgroundImage = [UIImage imageNamed:@"mine_record_background"];
    UIEdgeInsets insertsBackground = UIEdgeInsetsMake(15, 15, 10, 10);
    backgroundImage = [backgroundImage resizableImageWithCapInsets:insertsBackground resizingMode:UIImageResizingModeStretch];
    _backgroundImage.image = backgroundImage;
    
    _contentTextLabel.text = infoModel.trendcontent;
    if (![Util isEmpty:infoModel.trendcontent]) {
        CGSize contentSize = [infoModel.trendcontent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] context:nil].size;
        _textTopConstraint.constant = 13;
        backgroundViewHeight += 13 + contentSize.height;
    } else {
        _textTopConstraint.constant = -5;
    }
    if ([infoModel.trendsportstype integerValue] == 2) {
        _typeImageHeightConstraint.constant = 16;
        _energyLabelHeightConstraint.constant = 16;
        _typeImageTopConstraint.constant = 16;
        _energyLabelTopConstraint.constant = 16;
        NSString *energy = [NSString stringWithFormat:@"%@", infoModel.food_num];
        NSString *energyString = [NSString stringWithFormat:@"饮食摄入%@大卡", energy];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:energyString];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kFoodAttributedStringColor range:NSMakeRange(4, [energy length])];
        _clockInEnergyLabel.attributedText = attributedString;
        backgroundViewHeight += 45;
    } else if ([infoModel.trendsportstype integerValue] == 1){
        _typeImageHeightConstraint.constant = 16;
        _energyLabelHeightConstraint.constant = 16;
        _typeImageTopConstraint.constant = 16;
        _energyLabelTopConstraint.constant = 16;
        NSString *energy = [NSString stringWithFormat:@"%@", infoModel.sport_num];
        NSString *energyString = [NSString stringWithFormat:@"运动消耗%@大卡", energy];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:energyString];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kSportsAttributedStringColor range:NSMakeRange(4, [energy length])];
        _clockInEnergyLabel.attributedText = attributedString;
        backgroundViewHeight += 45;
    } else {
        _typeImageHeightConstraint.constant = 0;
        _energyLabelHeightConstraint.constant = 0;
        _typeImageTopConstraint.constant = -10;
        _energyLabelTopConstraint.constant = -10;
        _clockInEnergyLabel.attributedText = nil;
    }
    
    if ([Util isEmpty:infoModel.trendpicture]) {
        _contentImageRightConstraint.constant = SCREEN_WIDTH - 54;
    } else {
        _contentImageRightConstraint.constant = 3;
        [_contentImage setImageWithURL:[NSURL URLWithString:[Util urlMinePhoto:infoModel.trendpicture]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        _contentImage.contentMode = UIViewContentModeScaleAspectFit;
        backgroundViewHeight += SCREEN_WIDTH - 54;
    }
    _contentViewHeightConstraint.constant = backgroundViewHeight;
    _timeLabel.text = [NSString stringWithFormat:@"%@", [infoModel.created_time substringWithRange:NSMakeRange(11, 5)]];
}
- (CGFloat)heightForCell:(ClockInInforModel *)infoModel {
    CGFloat cellHeight = 0;
    if (![Util isEmpty:infoModel.trendcontent]) {
        CGSize contentSize = [infoModel.trendcontent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 74, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] context:nil].size;
        cellHeight += 13 + contentSize.height;
    }
    if ([infoModel.trendsportstype integerValue] == 1 || [infoModel.trendsportstype integerValue] == 2) {
        cellHeight += 32;
    }
    if (![Util isEmpty:infoModel.trendpicture]) {
        cellHeight += SCREEN_WIDTH - 54;
    }
//    if ([Util isEmpty:infoModel.trendcontent] && [Util isEmpty:infoModel.trendsportstype]) {
    cellHeight += 48;
//    } else {
//        cellHeight += 48;
//    }
    
    return cellHeight;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
