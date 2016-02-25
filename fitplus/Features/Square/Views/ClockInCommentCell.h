//
//  ClockInCommentCell.h
//  fitplus
//
//  Created by xlp on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockInCommentModel.h"

@interface ClockInCommentCell : UITableViewCell

- (CGFloat)heightForCell:(ClockInCommentModel *)data;
- (void)setupCellContent:(ClockInCommentModel *)data;

@end
