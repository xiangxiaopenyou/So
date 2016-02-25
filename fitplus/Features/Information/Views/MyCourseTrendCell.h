//
//  MyCourseTrendCell.h
//  fitplus
//
//  Created by xlp on 15/10/26.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCourseTrendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *trendTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *trendTimeLabel;

@end
