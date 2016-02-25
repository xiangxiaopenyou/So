//
//  DrysalteryCommentCell.m
//  fitplus
//
//  Created by xlp on 15/8/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DrysalteryCommentCell.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>
@interface DrysalteryCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DrysalteryCommentCell
- (void)setupCommentContent:(DrysalteryCommentModel *)model {
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 13.5;
    [_headImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:model.userPortait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    _nicknameLabel.text = model.userNickName;
    
    NSString *timeString = model.createdate;
    NSDate *date = [Util getTimeDate:timeString];
    if ([[Util compareDate:date] isEqualToString:@"今天"]) {
        timeString = [timeString substringWithRange:NSMakeRange(11, 5)];
    } else if ([[Util compareDate:date] isEqualToString:@"昨天"]) {
        timeString = [NSString stringWithFormat:@"昨天%@", [timeString substringWithRange:NSMakeRange(11, 5)]];
    } else {
        timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
    }
    _timeLabel.text = timeString;
    
    if ([model.type integerValue] == 2) {
        NSString *replyUserString = model.replyUserNickName;
        NSString *contentString = [NSString stringWithFormat:@"回复%@: %@", replyUserString, model.reply];
        NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [contentAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:87/255.0 green:172/255.0 blue:184/255.0 alpha:1.0] range:NSMakeRange(2, [replyUserString length])];
        _commentContentLabel.attributedText = contentAttributedString;
    } else {
        _commentContentLabel.text = model.commentcontent;
    }
}
- (CGFloat)heightForCellWith:(DrysalteryCommentModel *)model {
    CGFloat height = 55;
    NSString *contentString;
    if ([model.type integerValue] == 2) {
        contentString = [NSString stringWithFormat:@"回复%@: %@", model.replyUserNickName, model.reply];
    } else {
        contentString = model.commentcontent;
    }
    CGSize contentSize;
    contentSize = [contentString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] context:nil].size;
    height += contentSize.height;
    return height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
