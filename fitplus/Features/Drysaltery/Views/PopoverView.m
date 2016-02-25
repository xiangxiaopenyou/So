//
//  PopoverView.m
//  fitplus
//
//  Created by xlp on 15/9/24.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "PopoverView.h"
#import "CommonsDefines.h"

@implementation PopoverView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _array = titleArray;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectedRow = 0;
        [self addSubview:_tableView];
        
    }
    return self;
}
- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 46, SCREEN_WIDTH, 207);
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 207);
    }];
}
- (void)dismiss {
    [self dismiss:YES];
}
- (void)dismiss:(BOOL)animate {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 46, SCREEN_WIDTH, 0);
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    }];
}

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = _array[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == _selectedRow) {
        cell.textLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
        UIImageView *selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 15, 16, 16)];
        selectedImage.image = [UIImage imageNamed:@"training_type_selected"];
        [cell.contentView addSubview:selectedImage];
    } else {
        cell.textLabel.textColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 45.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
    [cell.contentView addSubview:line];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedRow = indexPath.row;
    if (self.selectRow) {
        self.selectRow(indexPath.row);
    }
    [tableView reloadData];
}
- (void)clickTableViewRow:(SelectRow)rowItem {
    _selectRow = rowItem;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
