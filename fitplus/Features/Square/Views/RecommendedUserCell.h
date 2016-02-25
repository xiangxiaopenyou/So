//
//  RecommendedUserCell.h
//  fitplus
//
//  Created by xlp on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface RecommendedUserCell : UITableViewCell
- (IBAction)attentionButtonClick:(id)sender;
- (void)setupInfomation:(UserInfo *)userInfo;

@end
