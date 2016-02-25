//
//  AttentionListTableViewCell.m
//  fitplus
//
//  Created by 陈 on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AttentionListTableViewCell.h"

@implementation AttentionListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attentionFansClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDATTENTION" object:self userInfo:nil];
}
@end
