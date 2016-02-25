//
//  PopoverView.h
//  fitplus
//
//  Created by xlp on 15/9/24.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectRow)(NSInteger index);

@interface PopoverView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, copy) SelectRow selectRow;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray;
- (void)show;
- (void)dismiss;
- (void)clickTableViewRow:(SelectRow)rowItem;
@end
