//
//  AttentionClockinContentCell.m
//  fitplus
//
//  Created by xlp on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AttentionClockinContentCell.h"
#import "Util.h"
#import "SquareCommons.h"
#import <UIImageView+AFNetworking.h>
#import "RecommendationModel.h"

@implementation AttentionClockinContentCell

- (void)setupCellViewWithDic:(ClockInDetailModel *)data {
    _model = data;
    
    _nicknameLabel.text = data.nickname;
    _headPortraitImage.layer.masksToBounds = YES;
    _headPortraitImage.layer.cornerRadius = 19.0;
    [_headPortraitImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:data.headPortraintString]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    [_headPortraitImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headPortraitRecognizer:)]];
    _headPortraitImage.userInteractionEnabled = YES;
    _contentLabel.text = data.clockinContent;
    if ([Util isEmpty:data.clockinPicture]) {
        _imageRightConstraint.constant = SCREEN_WIDTH;
        [self hidePictureTags];
    }
    else {
        [self hidePictureTags];
        _imageRightConstraint.constant = 0;
        [_contentImage setImageWithURL:[NSURL URLWithString:[Util urlPhoto:data.clockinPicture]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        _contentImage.userInteractionEnabled = YES;
        _contentImage.contentMode = UIViewContentModeScaleAspectFit;
        [_contentImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImageRecognizer:)]];
        [self showPictureTags];
    }
    NSString *timeString = data.created_time;
    NSDate *date = [Util getTimeDate:timeString];
    if ([[Util compareDate:date] isEqualToString:@"今天"]) {
        timeString = [timeString substringWithRange:NSMakeRange(11, 5)];
    } else if ([[Util compareDate:date] isEqualToString:@"昨天"]) {
        timeString = [NSString stringWithFormat:@"昨天%@", [timeString substringWithRange:NSMakeRange(11, 5)]];
    } else {
        timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
    }
    _timeLabel.text = timeString;
    
    if (data.clockinType == 2) {
        NSString *energy = [NSString stringWithFormat:@"%.1f", data.foodEnergy];
        NSString *energyString = [NSString stringWithFormat:@"饮食摄入%@大卡", energy];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:energyString];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kFoodAttributedStringColor range:NSMakeRange(4, [energy length])];
        _foodEnergyLabel.attributedText = attributedString;
    } else {
        NSString *energy = [NSString stringWithFormat:@"%.1f", data.sportsEnergy];
        NSString *energyString = [NSString stringWithFormat:@"运动消耗%@大卡", energy];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:energyString];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kSportsAttributedStringColor range:NSMakeRange(4, [energy length])];
        _foodEnergyLabel.attributedText = attributedString;
    }

    _commentNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)data.commentNumber];
    
    if (data.isfavorite == 2) {
        _likeImage.image = [UIImage imageNamed:@"dislike"];
    } else {
        _likeImage.image = [UIImage imageNamed:@"like"];
    }
    
    _likeNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)data.likeNumber];
    
}
- (CGFloat)cellHeightWithDic:(ClockInDetailModel *)data {
    CGFloat height = 70;
    if (![Util isEmpty:data.clockinContent]) {
        CGSize contentSize = [data.clockinContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 28, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] context:nil].size;
        height += contentSize.height;
    }
    height += 9;
    if (![Util isEmpty:data.clockinPicture]) {
        height += SCREEN_WIDTH + 9;
    }
    height += 83;
    return height;
    
}
- (void)showPictureTags {
    NSString *tagString = _model.clockinTag;
    if (![Util isEmpty:tagString]) {
        UIImage *tagImageRight = [UIImage imageNamed:@"tag_right"];
        UIImage *tagImageLeft = [UIImage imageNamed:@"tag_left"];
        UIEdgeInsets insets_right = UIEdgeInsetsMake(0, 52, 0, 10);
        UIEdgeInsets insets_left = UIEdgeInsetsMake(0, 10, 0, 52);
        tagImageRight = [tagImageRight resizableImageWithCapInsets:insets_right resizingMode:UIImageResizingModeStretch];
        tagImageLeft = [tagImageLeft resizableImageWithCapInsets:insets_left resizingMode:UIImageResizingModeStretch];
        //        tagString =  [tagString stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
        //        tagString =  [tagString stringByReplacingOccurrencesOfString:@"" withString:@""];
        NSArray *tagArray = [Util toArray:tagString];
        for (NSDictionary *tempDictionary in tagArray) {
            NSString *tagString = [tempDictionary objectForKey:@"tagName"];
            CGSize tagSize = [tagString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil]];
            CGSize twoWordsSize = [@"标签" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil]];
            NSInteger x = [[tempDictionary objectForKey:@"x"] floatValue] *SCREEN_WIDTH;
            if (x + tagSize.width + 70 - twoWordsSize.width > SCREEN_WIDTH) {
                x = SCREEN_WIDTH - tagSize.width - 71 + twoWordsSize.width;
            }
            NSInteger y = [[tempDictionary objectForKey:@"y"] floatValue] * SCREEN_WIDTH;
            if (y + 28 > SCREEN_WIDTH) {
                y = SCREEN_WIDTH - 29;
            }
            UIButton *tag = [UIButton buttonWithType:UIButtonTypeCustom];
            tag.frame = CGRectMake(x, y, tagSize.width + 70 - twoWordsSize.width, 28);
            if (x + (tagSize.width + 70 - twoWordsSize.width)/2 > SCREEN_WIDTH/2) {
                [tag setBackgroundImage:tagImageRight forState:UIControlStateNormal];
                tag.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                tag.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            } else {
                [tag setBackgroundImage:tagImageLeft forState:UIControlStateNormal];
                tag.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
                ;
                tag.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            }
            [tag setTitle:tagString forState:UIControlStateNormal];
            [tag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tag.titleLabel.font = [UIFont systemFontOfSize:14];
            [_contentImage addSubview:tag];
            
        }
    }
    _isShowTag = YES;

}
- (void)hidePictureTags {
    for (UIView *view in _contentImage.subviews) {
        [view removeFromSuperview];
    }
    _isShowTag = NO;
}
- (void)contentImageRecognizer:(UITapGestureRecognizer *)gesture {
    if (_isShowTag) {
        [self hidePictureTags];
    } else {
        [self showPictureTags];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)headPortraitRecognizer:(UITapGestureRecognizer *)gesture {
    [_delegate clickHeadPortrait:_model.userid];
}

- (IBAction)shareButtonClick:(id)sender {
    [_delegate clickShare:_model image:_contentImage.image];
}

- (IBAction)commentButtonClick:(id)sender {
    [_delegate clickComment:_model.id];
}

- (IBAction)likeButtonClick:(id)sender {
    if (_model.isfavorite == 2) {
        _model.isfavorite = 1;
        _model.likeNumber += 1;
        _likeImage.image = [UIImage imageNamed:@"like"];
        [RecommendationModel clockInLike:_model.id handler:^(id object, NSString *msg) {
            
        }];
        _likeNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)_model.likeNumber];
    } else {
        _model.isfavorite = 2;
        _model.likeNumber -= 1;
        _likeImage.image = [UIImage imageNamed:@"dislike"];
        [RecommendationModel clockInDislike:_model.id handler:^(id object, NSString *msg) {
        }];
        _likeNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)_model.likeNumber];
    }
}
@end
