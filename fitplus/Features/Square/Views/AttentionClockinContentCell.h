//
//  AttentionClockinContentCell.h
//  fitplus
//
//  Created by xlp on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockInDetailModel.h"
@protocol AttentionClockInDelegate<NSObject>
@optional
- (void)clickComment:(NSString *)trendId;
- (void)clickShare:(ClockInDetailModel *)model image:(UIImage *)image;
- (void)clickHeadPortrait:(NSString *)userid;
@end

@interface AttentionClockinContentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headPortraitImage;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;
@property (strong, nonatomic) IBOutlet UIImageView *energyTipOneImage;
@property (strong, nonatomic) IBOutlet UILabel *foodEnergyLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageRightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *commentImage;
@property (strong, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *likeImage;
@property (strong, nonatomic) IBOutlet UILabel *likeNumberLabel;
@property (copy, nonatomic) ClockInDetailModel *model;
@property (weak, nonatomic) id<AttentionClockInDelegate> delegate;
@property (assign, nonatomic) BOOL isShowTag;

- (IBAction)shareButtonClick:(id)sender;
- (IBAction)commentButtonClick:(id)sender;
- (IBAction)likeButtonClick:(id)sender;

- (void)setupCellViewWithDic:(ClockInDetailModel *)data;
- (CGFloat)cellHeightWithDic:(ClockInDetailModel *)data;

@end
