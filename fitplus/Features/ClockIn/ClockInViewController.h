//
//  ClockInViewController.h
//  fitplus
//
//  Created by 天池邵 on 15/6/25.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockInCommons.h"

@interface ClockInViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (assign, nonatomic) ClockInType type;
@end
