//
//  ClockInCommentCell.m
//  fitplus
//
//  Created by xlp on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInCommentCell.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>
#import "SquareCommons.h"

@interface ClockInCommentCell()
@property (strong, nonatomic) IBOutlet UIImageView *headPortraitImage;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation ClockInCommentCell
- (void)setupCellContent:(ClockInCommentModel *)data {
    _headPortraitImage.layer.masksToBounds = YES;
    _headPortraitImage.layer.cornerRadius = 14.5;
    [_headPortraitImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:data.firstUserHead]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    _nicknameLabel.text = data.firstUserNickname;
    
    NSString *timeString = data.created_time;
    NSDate *date = [Util getTimeDate:timeString];
    if ([[Util compareDate:date] isEqualToString:@"今天"]) {
        timeString = [timeString substringWithRange:NSMakeRange(11, 5)];
    } else if ([[Util compareDate:date] isEqualToString:@"昨天"]) {
        timeString = [NSString stringWithFormat:@"昨天%@", [timeString substringWithRange:NSMakeRange(11, 5)]];
    } else {
        timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
    }
    _timeLabel.text = timeString;
    
    if (data.commenttype == 2) {
        NSString *replyUserString = data.secondUserNickname;
        NSString *contentString = [NSString stringWithFormat:@"回复%@: %@", replyUserString, data.replyContent];
        NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [contentAttributedString addAttribute:NSForegroundColorAttributeName value:kCommentUserColor range:NSMakeRange(2, [replyUserString length])];
        _commentContentLabel.attributedText = contentAttributedString;
    } else {
        _commentContentLabel.text = data.commentContent;
    }
}
- (CGFloat)heightForCell:(ClockInCommentModel *)data {
    CGFloat height = 55;
    NSString *contentString;
    if (data.commenttype == 2) {
        contentString = [NSString stringWithFormat:@"回复%@: %@", data.secondUserNickname, data.replyContent];
    } else {
        contentString = data.commentContent;
    }
    CGSize contentSize;
    contentSize = [contentString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 66, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] context:nil].size;
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
