//
//  InformationTableViewCell.m
//  fitplus
//
//  Created by 陈 on 15/7/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)clickImage:(UIButton *)sender {
    NSDictionary * senderTag = @{@"SENDERTAG" :@(sender.tag)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLICKIMAGE" object:self userInfo:senderTag];
}

@end
