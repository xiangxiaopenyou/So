//
//  UserMessageTableViewCell.h
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *InfoHeadImageView;
@property (weak, nonatomic) IBOutlet UIButton *InfoNIcknameButton;
@property (weak, nonatomic) IBOutlet UILabel *InfoMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *InfoMessageTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *isReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
