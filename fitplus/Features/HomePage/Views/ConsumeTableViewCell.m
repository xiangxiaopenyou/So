//
//  consumeTableViewCell.m
//  fitplus
//
//  Created by 陈 on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ConsumeTableViewCell.h"

@implementation ConsumeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BUTTONCLICK" object:self userInfo:nil];
}

@end
