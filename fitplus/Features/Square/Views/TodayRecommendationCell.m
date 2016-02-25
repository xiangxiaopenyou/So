//
//  TodayRecommendationCell.m
//  fitplus
//
//  Created by xlp on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TodayRecommendationCell.h"
#import "CommonsDefines.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"

@interface TodayRecommendationCell()
@property (strong, nonatomic) UIImageView *leftImage;
@property (strong, nonatomic) UIImageView *centerImage;
@property (strong, nonatomic) UIImageView *rightImage;

@end

@implementation TodayRecommendationCell

- (void)setupWithImageDic:(NSArray *)array {
    if (array.count >= 1) {
        NSDictionary *tempDic = array[0];
        if (!_leftImage) {
            _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 6, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        }
        _leftImage.contentMode = UIViewContentModeScaleAspectFill;
        _leftImage.clipsToBounds = YES;
        [_leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
        _leftImage.userInteractionEnabled = YES;
        [_leftImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempDic[@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        [self.contentView addSubview:_leftImage];
    }
    
    if (array.count >=2) {
          NSDictionary *tempDic1 = array[1];
        if (!_centerImage) {
            _centerImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 36)/3 + 18, 6, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        }
        _centerImage.contentMode = UIViewContentModeScaleAspectFill;
        _centerImage.clipsToBounds = YES;
        [_centerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCenter)]];
        _centerImage.userInteractionEnabled = YES;
        [_centerImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempDic1[@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        [self.contentView addSubview:_centerImage];
    }
    
    if (array.count >= 3) {
        NSDictionary *tempDic2 = array[2];
        if (!_rightImage) {
            _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(2*(SCREEN_WIDTH - 36)/3 + 22, 6, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        }
        _rightImage.contentMode = UIViewContentModeScaleAspectFill;
        _rightImage.clipsToBounds = YES;
        [_rightImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRight)]];
        _rightImage.userInteractionEnabled = YES;
        [_rightImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempDic2[@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
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
- (void)clickImage:(ClickPhoto)click {
    _clickItem = click;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
