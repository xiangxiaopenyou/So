//
//  EnglobeImageTableViewCell.m
//  fitplus
//
//  Created by 陈 on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "EnglobeImageTableViewCell.h"

@implementation EnglobeImageTableViewCell

- (void)awakeFromNib {
 
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deletebuttonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BUTTONCLICK" object:self userInfo:nil];
}

@end
