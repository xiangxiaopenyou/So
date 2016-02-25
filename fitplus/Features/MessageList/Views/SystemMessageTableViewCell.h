//
//  SystemMessageTableViewCell.h
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *systemHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *systemMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *systemMessageTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *systemMessageImageView;

@end
