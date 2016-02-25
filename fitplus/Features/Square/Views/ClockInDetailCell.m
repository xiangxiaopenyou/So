//
//  ClockInDetailCell.m
//  fitplus
//
//  Created by xlp on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInDetailCell.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>
#import "SquareCommons.h"
#import "RecommendationModel.h"
#import "AddAttentionModel.h"

@interface ClockInDetailCell()
@property (strong, nonatomic) IBOutlet UIImageView *headPortraintImage;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *attentionButton;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;
@property (strong, nonatomic) IBOutlet UILabel *energyLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageRightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *likeImage;
@property (strong, nonatomic) IBOutlet UILabel *likeNumberLabel;

@property (copy, nonatomic) NSDictionary *dictionary;
@property (assign, nonatomic) BOOL isLike;
@property (assign, nonatomic) NSInteger likeNumber;
@property (assign, nonatomic) BOOL isShowTag;



@end

@implementation ClockInDetailCell
- (void)setupCellViewWithModel:(NSDictionary *)data {
    _dictionary = data;
    _nicknameLabel.text = data[@"nickname"];
    _headPortraintImage.layer.masksToBounds = YES;
    _headPortraintImage.layer.cornerRadius = 19.0;
    [_headPortraintImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:data[@"portrait"]]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    _headPortraintImage.userInteractionEnabled = YES;
    [_headPortraintImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headPortraintRecognizer:)]];
    _contentLabel.text = data[@"trendcontent"];
    if ([Util isEmpty:data[@"trendpicture"]]) {
        _imageRightConstraint.constant = SCREEN_WIDTH;
    }
    else {
        [self hidePictureTags];
        _imageRightConstraint.constant = 0;
        [_contentImage setImageWithURL:[NSURL URLWithString:[Util urlPhoto:data[@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        _contentImage.contentMode = UIViewContentModeScaleAspectFit;
        _contentImage.userInteractionEnabled = YES;
        [_contentImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImageRecognizer:)]];
        [self showPictureTags];
    }
    NSString *timeString = data[@"created_time"];
    NSDate *date = [Util getTimeDate:timeString];
    if ([[Util compareDate:date] isEqualToString:@"今天"]) {
        timeString = [timeString substringWithRange:NSMakeRange(11, 5)];
    } else if ([[Util compareDate:date] isEqualToString:@"昨天"]) {
        timeString = [NSString stringWithFormat:@"昨天%@", [timeString substringWithRange:NSMakeRange(11, 5)]];
    } else {
        timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
    }
    _timeLabel.text = timeString;
    
    if ([data[@"flag"] integerValue] == 5) {
        _attentionButton.hidden = YES;
    } else {
        if ([data[@"flag"] integerValue] == 2) {
            _attentionButton.hidden = YES;
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"each_attention"] forState:UIControlStateNormal];
        } else if ([data[@"flag"] integerValue] == 4) {
            _attentionButton.hidden = YES;
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"is_attention"] forState:UIControlStateNormal];
        } else {
            _attentionButton.hidden = NO;
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
        }
    }
    
    if ([data[@"trendsportstype"] integerValue] == 2) {
        
        if (![Util isEmpty:data[@"food_num"]]) {
            NSString *energy = [NSString stringWithFormat:@"%@", data[@"food_num"]];
            NSString *energyString = [NSString stringWithFormat:@"饮食摄入%@大卡", energy];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:energyString];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kFoodAttributedStringColor range:NSMakeRange(4, [energy length])];
            _energyLabel.attributedText = attributedString;
        }
    } else {
        if (![Util isEmpty:data[@"sport_num"]]) {
            NSString *energy = [NSString stringWithFormat:@"%@", data[@"sport_num"]];
            NSString *energyString = [NSString stringWithFormat:@"运动消耗%@大卡", energy];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:energyString];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kSportsAttributedStringColor range:NSMakeRange(4, [energy length])];
            _energyLabel.attributedText = attributedString;
        }
    }
    if (![Util isEmpty:data[@"trendscomment_num"]]) {
        _commentNumberLabel.text = [NSString stringWithFormat:@"%@", data[@"trendscomment_num"]];
    }
    if ([data[@"isfavorite"] integerValue] == 2) {
        _likeImage.image = [UIImage imageNamed:@"dislike"];
        _isLike = NO;
    } else {
        _likeImage.image = [UIImage imageNamed:@"like"];
        _isLike = YES;
    }
    if (![Util isEmpty:data[@"trendsfavorite_num"]]) {
        _likeNumberLabel.text = [NSString stringWithFormat:@"%@", data[@"trendsfavorite_num"]];
        _likeNumber = [data[@"trendsfavorite_num"] integerValue];
    }
    
}
- (CGFloat)cellHeightWithModel:(NSDictionary *)data {
    CGFloat height = 58;
    if (![Util isEmpty:data[@"trendcontent"]]) {
        CGSize contentSize = [data[@"trendcontent"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 28, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] context:nil].size;
        height += contentSize.height;
    }
    height += 9;
    if (![Util isEmpty:data[@"trendpicture"]]) {
        height += SCREEN_WIDTH + 9;
    }
    height += 83;
    return height;
}
- (void)contentImageRecognizer:(UITapGestureRecognizer *)gesture {
    if (_isShowTag) {
        [self hidePictureTags];
    } else {
        [self showPictureTags];
    }
}
- (void)showPictureTags {
    NSString *tagString = _dictionary[@"palycard_tag"];
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
            }
            else{
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)headPortraintRecognizer:(UITapGestureRecognizer *)gesture {
    [_delegate clickHeadPortrait];
}
- (IBAction)shareButtonClick:(id)sender {
    [_delegate clickShare:_contentImage.image];
}

- (IBAction)attentionButtonClick:(id)sender {
    [AddAttentionModel addAttentionWithfrendid:_dictionary[@"userid"] handler:^(id object, NSString *msg) {
        [_delegate clickAttention];
    }];
}

- (IBAction)commentButtonClick:(id)sender {
    [_delegate clickComment];
}

- (IBAction)likeButtonClick:(id)sender {
    if (_isLike) {
        _isLike = NO;
        _likeImage.image = [UIImage imageNamed:@"dislike"];
        [RecommendationModel clockInDislike:_dictionary[@"id"] handler:^(id object, NSString *msg) {
        }];
        _likeNumber -= 1;
        _likeNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)_likeNumber];
    } else {
        _isLike = YES;
        _likeImage.image = [UIImage imageNamed:@"like"];
        [RecommendationModel clockInLike:_dictionary[@"id"] handler:^(id object, NSString *msg) {
        }];
        _likeNumber += 1;
        _likeNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)_likeNumber];
    }
}
@end
