//
//  ClockInDetailCell.h
//  fitplus
//
//  Created by xlp on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockInDetailModel.h"
@protocol ClockInDetailDelegate<NSObject>
@optional
- (void)clickComment;
- (void)clickShare:(UIImage *)image;
- (void)clickAttention;
- (void)clickHeadPortrait;
@end
@interface ClockInDetailCell : UITableViewCell

- (IBAction)shareButtonClick:(id)sender;
- (IBAction)attentionButtonClick:(id)sender;
- (IBAction)commentButtonClick:(id)sender;
- (IBAction)likeButtonClick:(id)sender;

@property (weak, nonatomic) id<ClockInDetailDelegate>delegate;

- (void)setupCellViewWithModel:(NSDictionary *)data;
- (CGFloat)cellHeightWithModel:(NSDictionary *)data;

@end
