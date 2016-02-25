//
//  ChooseLabelViewController.m
//  fitplus
//
//  Created by xlp on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChooseLabelViewController.h"
#import "LabelModel.h"
#import "LimitResultModel.h"
#import <MJRefresh/MJRefresh.h>
#import "Util.h"
#import "RBNoticeHelper.h"

@interface ChooseLabelViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *labelSearchBar;
@property (assign, nonatomic) BOOL isSearch;
@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) NSMutableArray *labelArray;

@end

@implementation ChooseLabelViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"选择标签";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.tableFooterView = [UIView new];
    [_tableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchLabelList];
    }]];
    _limit = 0;
    _isSearch = NO;
    [self fetchLabelList];
}

- (void)fetchLabelList {
    [LabelModel fetchLabelListWith:_labelSearchBar.text limit:_limit handler:^(id object, NSString *msg) {
        [_tableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *tempModel = [LimitResultModel new];
            tempModel = object;
            if (_limit == 0) {
                _labelArray = [tempModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_labelArray mutableCopy];
                [tempArray addObjectsFromArray:tempModel.result];
                _labelArray = tempArray;
            }
            [_tableView reloadData];
            BOOL haveMore = tempModel.haveMore;
            if (haveMore) {
                _limit = tempModel.limit;
                _tableView.footer.hidden = NO;
            } else {
                [_tableView.footer noticeNoMoreData];
                _tableView.footer.hidden = YES;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return _labelArray.count + 1;
    } else {
        return _labelArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LabelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    LabelModel *model = [LabelModel new];
    if (_isSearch) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"自定义话题: %@", _labelSearchBar.text];
        } else {
            model = [_labelArray objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = model.labelName;
        }
    } else {
        model = [_labelArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.labelName;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LabelModel *model = [LabelModel new];
    if (!_isSearch) {
        model = [_labelArray objectAtIndex:indexPath.row];
        [_delegate chooseLabel:model.labelName id:[model.labelId integerValue]];
         [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (indexPath.row == 0) {
            if ([_labelSearchBar.text length] > 15) {
                [RBNoticeHelper showNoticeAtViewController:self msg:@"字数不要超过15个哦~"];
            } else {
                [_delegate chooseLabel:_labelSearchBar.text id:0];
                 [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            model = [_labelArray objectAtIndex:indexPath.row - 1];
            [_delegate chooseLabel:model.labelName id:[model.labelId integerValue]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
   
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyString = searchBar.text;
    if ([Util isEmpty:keyString]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先输入关键字再搜索"];
        return;
    }
    _isSearch = YES;
    [searchBar resignFirstResponder];
    _limit = 0;
    [self fetchLabelList];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        _isSearch = NO;
    } else {
        _isSearch = YES;
    }
    _limit = 0;
    [self fetchLabelList];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
