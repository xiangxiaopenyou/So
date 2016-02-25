//
//  FansListTableViewCell.h
//  fitplus
//
//  Created by 陈 on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FansListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *otherHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *fansButton;

@end
