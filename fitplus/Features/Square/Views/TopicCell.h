//
//  TopicCell.h
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickPhoto)(NSInteger index);

@interface TopicCell : UITableViewCell

@property (strong, nonatomic) ClickPhoto clickItem;

- (void)clickImage:(ClickPhoto)item;
- (void)setupWithDic:(NSDictionary *)dic;

@end
