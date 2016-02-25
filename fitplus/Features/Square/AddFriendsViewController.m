//
//  AddFriendsViewController.m
//  fitplus
//
//  Created by xlp on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "InviteWeChatCell.h"
#import "RecommendedUserCell.h"
#import "UserInfoModel.h"
#import "SquareCommons.h"
#import "LimitResultModel.h"
#import <MJRefresh/MJRefresh.h>
#import "UserInfo.h"
#import "Util.h"
#import "RBNoticeHelper.h"
#import "InformationViewController.h"
#import "AppDelegate.h"

@interface AddFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *friendsTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *friendsSearchBar;

@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) NSMutableArray *usersArray;
@property (assign, nonatomic) BOOL isSearch;
@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加好友";
    
    [self initRefresh];
    _friendsTableView.tableFooterView = [UIView new];
    [self fetchRecommendedUsersList];
    //[_friendsSearchDisplayController.searchBar setPlaceholder:@"搜索"];
}
- (void)viewWillAppear:(BOOL)animated {
    //self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initRefresh {
    [_friendsTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchRecommendedUsersList];
    }]];
}
- (void)fetchRecommendedUsersList {
    _isSearch = NO;
    [UserInfoModel fetchRecommendedUsers:_limit handler:^(id object, NSString *msg) {
        [_friendsTableView.header endRefreshing];
        [_friendsTableView.footer endRefreshing];
        if (msg) {
        } else {
            LimitResultModel *limitModel = [LimitResultModel new];
            limitModel = object;
            if (_limit == 0) {
                _usersArray = [limitModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_usersArray mutableCopy];
                [tempArray addObjectsFromArray:limitModel.result];
                _usersArray = tempArray;
            }
            [_friendsTableView reloadData];
            BOOL haveMore = limitModel.haveMore;
            if (haveMore) {
                _limit = limitModel.limit;
            } else {
                [_friendsTableView.footer noticeNoMoreData];
            }
            
        }
        
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber = 0;
    switch (section) {
        case 0:
            rowNumber = 1;
            break;
        case 1:
            rowNumber = _usersArray.count;
        default:
            break;
    }
    return rowNumber;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"";
    if (indexPath.section == 0) {
        CellIdentifier = @"WeChatCell";
        InviteWeChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[InviteWeChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    } else {
        CellIdentifier = @"UserCell";
        RecommendedUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[RecommendedUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UserInfo *userInfo = [_usersArray objectAtIndex:indexPath.row];
        [cell setupInfomation:userInfo];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        UserInfo *tempInfo = [_usersArray objectAtIndex:indexPath.row];
        InformationViewController *informationViewController = [[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
        informationViewController.friendid = tempInfo.userid;
        [self.navigationController pushViewController:informationViewController animated:YES];
    } else {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate shareWithWeChatFriends:@"一起来健身吧!" Description:@"加入线上健身俱乐部，和帅哥美女一起健身，来，约着跑起来~" Url:@"http://jianshen.so" Photo:@"share_image"];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    } else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 200, 30)];
    if (_isSearch) {
        if (_usersArray.count == 0) {
            headerLabel.text = @"无搜索结果";
        } else {
            headerLabel.text = @"搜索结果";
        }
    } else {
        headerLabel.text = @"推荐用户";
    }
    headerLabel.font = [UIFont systemFontOfSize:13];
    headerLabel.textColor = kCommonTextColor;
    [headerView addSubview:headerLabel];
    
    return headerView;
}

#pragma mark - SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyString = searchBar.text;
    if ([Util isEmpty:keyString]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先输入关键字再搜索"];
        return;
    }
    [searchBar resignFirstResponder];
    [self searchFriendsWith:keyString];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        [self fetchRecommendedUsersList];
    } else {
        [self searchFriendsWith:searchText];
    }
}
- (void)searchFriendsWith:(NSString *)keywords {
    _isSearch = YES;
    [UserInfoModel searchFriendsWith:keywords handler:^(id object, NSString *msg) {
        if (msg) {
        } else {
            _usersArray = [object mutableCopy];
            [_friendsTableView reloadData];
            [_friendsTableView.footer noticeNoMoreData];
        }
    }];
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
