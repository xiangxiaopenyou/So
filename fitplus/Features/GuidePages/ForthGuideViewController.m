//
//  ForthGuideViewController.m
//  fitplus
//
//  Created by xlp on 15/11/9.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "ForthGuideViewController.h"
#import "CommonsDefines.h"
#import "CourseCell.h"
#import "CourseModel.h"
#import "UserInfoModel.h"
#import <MBProgressHUD.h>

@interface ForthGuideViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *selectedCourseArray;

@end

@implementation ForthGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"欢迎";
     //_recommendedCourseArray = [NSMutableArray arrayWithObjects:@(0), @(0), @(0), @(0), @(0), @(0), @(0), @(0), nil];
    _selectedCourseArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _recommendedCourseArray.count; i ++) {
        [_selectedCourseArray addObject:@(i)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recommendedCourseArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / 2 + 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CourseCell";
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([_selectedCourseArray containsObject:@(indexPath.row)]) {
        cell.selectButton.selected = YES;
    } else {
        cell.selectButton.selected = NO;
    }
    CourseModel *tempModel = _recommendedCourseArray[indexPath.row];
    [cell setupContent:tempModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_selectedCourseArray containsObject:@(indexPath.row)]) {
        [_selectedCourseArray removeObject:@(indexPath.row)];
    } else {
        [_selectedCourseArray addObject:@(indexPath.row)];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)chooseClick:(id)sender {
    if (_selectedCourseArray.count == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableString *courseIdString = [NSMutableString string];
        for (NSString *rowIndex in _selectedCourseArray) {
            CourseModel *tempModel = _recommendedCourseArray[[rowIndex integerValue]];
            [courseIdString appendFormat:@"%@,", tempModel.courseId];
        }
        [courseIdString deleteCharactersInRange:NSMakeRange(courseIdString.length - 1, 1)];
        [UserInfoModel addRecommendedCourseWith:courseIdString handler:^(id object, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!msg) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

@end
