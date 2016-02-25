//
//  EnglobeTableViewCell.h
//  fitplus
//
//  Created by 陈 on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnglobeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
