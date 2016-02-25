//
//  TodayRecommendationCell.h
//  fitplus
//
//  Created by xlp on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickPhoto)(NSInteger index);

@interface TodayRecommendationCell : UITableViewCell

@property (strong, nonatomic) ClickPhoto clickItem;
- (void)clickImage:(ClickPhoto)click;

- (void)setupWithImageDic:(NSArray *)array;


@end
