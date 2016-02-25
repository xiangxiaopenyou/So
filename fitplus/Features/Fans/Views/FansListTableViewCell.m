//
//  FansListTableViewCell.m
//  fitplus
//
//  Created by 陈 on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FansListTableViewCell.h"

@implementation FansListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)attentionFansClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ATTENTIONFANS" object:self userInfo:nil];
}

@end
