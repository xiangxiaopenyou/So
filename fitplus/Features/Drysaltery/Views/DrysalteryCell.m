//
//  DrysalteryCell.m
//  fitplus
//
//  Created by xlp on 15/8/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DrysalteryCell.h"
#import "Util.h"
#include <UIImageView+AFNetworking.h>

#define kHeadBorderColor [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]

@interface DrysalteryCell()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *readTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *DrysalteryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *drysalteryTypeImage;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation DrysalteryCell
- (void)setupDrysalteryContentWithModel:(DrysalteryModel *)model {
    
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 2.0;
//
    _backgroundImage.layer.masksToBounds = YES;
    _backgroundImage.layer.cornerRadius = 2.0;
    [_backgroundImage setImageWithURL:[NSURL URLWithString:[Util urlPhoto:model.headimage]] placeholderImage:[UIImage imageNamed:@"default_image"]];
    
    _userHeadImage.layer.masksToBounds = YES;
    _userHeadImage.layer.cornerRadius = 18.0;
    _userHeadImage.layer.borderWidth = 1.0;
    _userHeadImage.layer.borderColor = kHeadBorderColor.CGColor;
    [_userHeadImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:model.portrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    
    _likeNumberLabel.text = [NSString stringWithFormat:@"%@人觉得有用", model.commendSum];
    _readTimesLabel.text = [NSString stringWithFormat:@"%@次浏览", model.readsum];
    
    _DrysalteryTitleLabel.text = model.title;
    _nicknameLabel.text = model.nickname;
    _locationLabel.text = model.area;
    
    if ([model.labelName isEqualToString:@"精选"]) {
        _drysalteryTypeImage.image = [UIImage imageNamed:@"label_choice"];
    } else {
        _drysalteryTypeImage.image = [UIImage imageNamed:@"label_hot"];
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
