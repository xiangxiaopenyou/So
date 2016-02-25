//
//  PopularUserCell.m
//  fitplus
//
//  Created by xlp on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PopularUserCell.h"
#import "CommonsDefines.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"
#import "AddAttentionModel.h"

@interface PopularUserCell()
@property (strong, nonatomic) UIImageView *leftImage;
@property (strong, nonatomic) UIImageView *centerImage;
@property (strong, nonatomic) UIImageView *rightImage;
@property (assign, nonatomic) NSInteger isAttention;
@property (copy, nonatomic) NSMutableDictionary *dictionary;

@end

@implementation PopularUserCell

- (void)setupCellContent:(NSDictionary *)dic {
    _dictionary = [dic mutableCopy];
    _headportraitImage.layer.masksToBounds = YES;
    _headportraitImage.layer.cornerRadius = 18.0;
    [_headportraitImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:dic[@"portrait"]]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    _nicknameLabel.text = [NSString stringWithFormat:@"%@", dic[@"nickname"]];
    _isAttention = [_dictionary[@"flag"] integerValue];
    if (_isAttention == 5) {
        _attentionButton.hidden = YES;
    } else {
        _attentionButton.hidden = NO;
        if (_isAttention == 1 || _isAttention == 3) {
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
        } else if (_isAttention == 2) {
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"each_attention"] forState:UIControlStateNormal];
        } else {
            [_attentionButton setBackgroundImage:[UIImage imageNamed:@"is_attention"] forState:UIControlStateNormal];
        }
    }
    [_leftImage removeFromSuperview];
    [_centerImage removeFromSuperview];
    [_rightImage removeFromSuperview];
    NSArray *tempArray = dic[@"trend_data"];
    if (tempArray.count >= 1) {
        if (!_leftImage) {
            _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 58, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        }
        _leftImage.contentMode = UIViewContentModeScaleAspectFill;
        _leftImage.clipsToBounds = YES;
        [_leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
        _leftImage.userInteractionEnabled = YES;
        [_leftImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempArray[0][@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        [self.contentView addSubview:_leftImage];
    }
    if (tempArray.count >= 2) {
        if (!_centerImage) {
            _centerImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 36)/3 + 18, 58, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        }
        _centerImage.contentMode = UIViewContentModeScaleAspectFill;
        _centerImage.clipsToBounds = YES;
        [_centerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCenter)]];
        _centerImage.userInteractionEnabled = YES;
        [_centerImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempArray[1][@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        [self.contentView addSubview:_centerImage];
    }
    
    if (tempArray.count >= 3) {
        if (!_rightImage) {
            _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(2*(SCREEN_WIDTH - 36)/3 + 22, 58, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        }
        _rightImage.contentMode = UIViewContentModeScaleAspectFill;
        _rightImage.clipsToBounds = YES;
        [_rightImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRight)]];
        _rightImage.userInteractionEnabled = YES;
        [_rightImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempArray[2][@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        [self.contentView addSubview:_rightImage];
    }
}
- (void)clickLeft {
    if (_clickItem != nil) {
        _clickItem(1);
    }
}
- (void)clickCenter {
    if (_clickItem != nil) {
        _clickItem(2);
    }
}
- (void)clickRight {
    if (_clickItem != nil) {
        _clickItem(3);
    }
}
- (void)clickImage:(ClickPhoto)item {
    _clickItem = item;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attentionButtonClick:(id)sender {
    if (_isAttention == 1) {
        [AddAttentionModel addAttentionWithfrendid:_dictionary[@"userid"] handler:^(id object, NSString *msg) {
            if (!msg) {
//                [_attentionButton setBackgroundImage:[UIImage imageNamed:@"is_attention"] forState:UIControlStateNormal];
                _attention(YES);
//                _isAttention = 4;
//                [_dictionary setObject:@(4) forKey:@"flag"];
            }
            
        }];
        
    } else if (_isAttention == 2 || _isAttention == 4) {
//        [_attentionButton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
        [AddAttentionModel cancelAttentionWithFriendId:_dictionary[@"userid"] handler:^(id object, NSString *msg) {
            _attention(YES);
        }];
//        if (_isAttention == 2) {
//            _isAttention = 3;
//            [_dictionary setObject:@(3) forKey:@"flag"];
//        } else {
//            _isAttention = 1;
//            [_dictionary setObject:@(1) forKey:@"flag"];
//        }
        
    } else {
//        [_attentionButton setBackgroundImage:[UIImage imageNamed:@"each_attention"] forState:UIControlStateNormal];
        [AddAttentionModel addAttentionWithfrendid:_dictionary[@"userid"] handler:^(id object, NSString *msg) {
            _attention(YES);
        }];
//        _isAttention = 2;
//        [_dictionary setObject:@(2) forKey:@"flag"];
    }
}
- (void)clickAttention:(ClickAttention)att {
    _attention = att;
}
@end
