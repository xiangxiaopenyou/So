//
//  SquareViewController.h
//  fitplus
//
//  Created by xlp on 15/7/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *viewForTable;
@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITableView *recommendationTableView;
@property (strong, nonatomic) IBOutlet UITableView *attentionTableView;
@property (strong, nonatomic) IBOutlet UITableView *topicTableView;
@property (strong, nonatomic) IBOutlet UILabel *selectedLabel;
- (IBAction)recommendationButtonClick:(id)sender;
- (IBAction)attentionButtonClick:(id)sender;
- (IBAction)topicButtonClick:(id)sender;

@end
