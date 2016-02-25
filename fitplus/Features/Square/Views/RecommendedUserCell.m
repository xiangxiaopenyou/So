//
//  RecommendedUserCell.m
//  fitplus
//
//  Created by xlp on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RecommendedUserCell.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"
#import "AddAttentionModel.h"
@interface RecommendedUserCell()
@property (strong, nonatomic) IBOutlet UIImageView *headPortraitImage;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *introduceLabel;
@property (strong, nonatomic) IBOutlet UIButton *attentionButton;
@property (copy, nonatomic) UserInfo *userInfoModel;

@end

@implementation RecommendedUserCell
- (void)setupInfomation:(UserInfo *)userInfo {
    _userInfoModel = userInfo;
    
    _headPortraitImage.layer.masksToBounds = YES;
    _headPortraitImage.layer.cornerRadius = 19;
    [_headPortraitImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:userInfo.headportrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    
    _nicknameLabel.text = userInfo.nickname;
    
    _introduceLabel.text = userInfo.introduce;
    
    if ([userInfo.userid isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey]]) {
        _attentionButton.hidden = YES;
    } else {
        _attentionButton.hidden = NO;
        if (userInfo.isAttention == 1 || userInfo.isAttention == 3) {
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
        } else if (userInfo.isAttention == 2) {
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"each_attention"] forState:UIControlStateNormal];
        } else {
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"is_attention"] forState:UIControlStateNormal];
        }
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attentionButtonClick:(id)sender {
    if (_userInfoModel.isAttention == 2 || _userInfoModel.isAttention == 4) {
        [_attentionButton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
        [AddAttentionModel cancelAttentionWithFriendId:_userInfoModel.userid handler:^(id object, NSString *msg) {
        }];
        _userInfoModel.isAttention = _userInfoModel.isAttention == 2 ? 3 : 1;
    } else if (_userInfoModel.isAttention == 1) {
        [_attentionButton setBackgroundImage:[UIImage imageNamed:@"is_attention"] forState:UIControlStateNormal];
        [AddAttentionModel addAttentionWithfrendid:_userInfoModel.userid handler:^(id object, NSString *msg) {
        }];
        _userInfoModel.isAttention = 4;
    } else {
        [_attentionButton setBackgroundImage:[UIImage imageNamed:@"each_attention"] forState:UIControlStateNormal];
        [AddAttentionModel addAttentionWithfrendid:_userInfoModel.userid handler:^(id object, NSString *msg) {
        }];
        _userInfoModel.isAttention = 2;
    }
    
}
@end
