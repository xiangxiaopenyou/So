//
//  TopicCell.m
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TopicCell.h"
#import "CommonsDefines.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>



@interface TopicCell()
@property (strong, nonatomic) IBOutlet UIImageView *leftImage;
@property (strong, nonatomic) IBOutlet UIImageView *centerImage;
@property (strong, nonatomic) IBOutlet UIImageView *rightImage;

@property (strong, nonatomic) IBOutlet UILabel *topicNameLabel;

@end

@implementation TopicCell

- (void)setupWithDic:(NSDictionary *)dic {
    if (![Util isEmpty:dic[@"name"]]) {
        _topicNameLabel.text = dic[@"name"];
    } else {
        _topicNameLabel.text = @"";
    }
    NSArray *tempArray = dic[@"trend_data"];
    if (tempArray.count >= 1) {
        _leftImage.clipsToBounds = YES;
        [_leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
        _leftImage.userInteractionEnabled = YES;
        [_leftImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempArray[0][@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
    }
    
    if (tempArray.count >= 2) {
        _centerImage.clipsToBounds = YES;
        [_centerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCenter)]];
        _centerImage.userInteractionEnabled = YES;
        [_centerImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempArray[1][@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
    }
    
    if (tempArray.count >= 3) {
        _rightImage.clipsToBounds = YES;
        [_rightImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRight)]];
        _rightImage.userInteractionEnabled = YES;
        [_rightImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempArray[2][@"trendpicture"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
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

@end
