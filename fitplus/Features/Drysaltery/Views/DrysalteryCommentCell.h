//
//  DrysalteryCommentCell.h
//  fitplus
//
//  Created by xlp on 15/8/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrysalteryCommentModel.h"

@interface DrysalteryCommentCell : UITableViewCell

- (void)setupCommentContent:(DrysalteryCommentModel *)model;
- (CGFloat)heightForCellWith:(DrysalteryCommentModel *)model;

@end
