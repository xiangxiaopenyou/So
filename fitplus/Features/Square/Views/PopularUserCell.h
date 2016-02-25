//
//  PopularUserCell.h
//  fitplus
//
//  Created by xlp on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickAttention)(BOOL isClick);
typedef void (^ClickPhoto)(NSInteger index);
@interface PopularUserCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headportraitImage;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UIButton *attentionButton;

@property (strong, nonatomic) ClickPhoto clickItem;
@property (copy, nonatomic) ClickAttention attention;
- (void)clickImage:(ClickPhoto)item;
- (void)clickAttention:(ClickAttention)att;
- (IBAction)attentionButtonClick:(id)sender;
- (void)setupCellContent:(NSDictionary *)dic;

@end
