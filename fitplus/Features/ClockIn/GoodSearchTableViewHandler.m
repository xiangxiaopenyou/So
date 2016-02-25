//
//  FoodSearchTableViewHandler.m
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "GoodSearchTableViewHandler.h"
#import "NSArray+RBAddition.h"
#import "RBNoticeHelper.h"
#import "FoodModel.h"
#import "SportModel.h"
#import "LimitResultModel.h"
#import "ClockInGoodModel.h"

@interface GoodSearchTableViewHandler ()
@property (weak, nonatomic) UISearchDisplayController *searchDisplayController;
@property (copy, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UISearchBar *searchBar;
@property (copy, nonatomic) TableViewSelectedHandler handler;

@property (assign, nonatomic) NSInteger limit;
@property (assign, nonatomic) FetchType fetchType;
@end

@implementation GoodSearchTableViewHandler

- (instancetype)initWithSearchDisplayController:(UISearchDisplayController *)searchDisplayController handler:(TableViewSelectedHandler)handler fetchType:(FetchType)fetchType {
    self = [super init];
    if (self) {
        _searchDisplayController = searchDisplayController;
        _tableView = searchDisplayController.searchResultsTableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _searchBar = searchDisplayController.searchBar;
        _searchBar.delegate = self;
        _handler = handler;
        _fetchType = fetchType;
    }
    
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [_tableView reloadData];
}

- (void)appendDataSource:(NSArray *)dataSource {
    NSMutableArray *tempDataSource = [dataSource mutableCopy];
    [tempDataSource addObjectsFromArray:dataSource];
    _dataSource = tempDataSource;
    [_tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FoodSearchCellIdentifier = @"FoodSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FoodSearchCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoodSearchCellIdentifier];
    }
    
    cell.textLabel.text = [_dataSource[indexPath.row] goodName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    !_handler ?: _handler(_dataSource[indexPath.row], indexPath);
    
    [_searchDisplayController setActive:NO animated:YES];
}

#pragma mark - SearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    
    [self searchGood:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchGood:(NSString *)name {
    id fetchHandler = ^(LimitResultModel *limitModel, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtView:[UIApplication sharedApplication].keyWindow y:64 msg:msg];
        } else {
            if (limitModel.haveMore) {
                _limit = limitModel.limit;
            }
            [self setDataSource:limitModel.result];
        }
    };
    
    if (_fetchType == Fetch_Food) {
        [FoodModel fetchGoodByName:name limit:_limit handler:fetchHandler];
    } else {
        [SportModel fetchGoodByName:name limit:_limit handler:fetchHandler];
    }
}



@end
