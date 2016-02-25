//
//  InviteWeChatCell.m
//  fitplus
//
//  Created by xlp on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "InviteWeChatCell.h"

@interface InviteWeChatCell()
@property (strong, nonatomic) IBOutlet UIImageView *headPortraintImage;

@end

@implementation InviteWeChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
