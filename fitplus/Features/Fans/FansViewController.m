//
//  FansViewController.m
//  fitplus
//
//  Created by 陈 on 15/7/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FansViewController.h"
#import "FansDataModel.h"
#import "FansListTableViewCell.h"
#import "LimitResultModel.h"
#import "InformationViewController.h"
#import <MJRefresh.h>
#import <UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>
#import "RBNoticeHelper.h"
#import "Util.h"
#import "AddAttentionModel.h"
#import "CommonsDefines.h"
#define imageUrlStr @"http://7u2h8u.com1.z0.glb.clouddn.com/"

@interface FansViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *members;
@end

@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self refreshinit];
    [self refreshGetFans];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ATTENTIONFANS" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionFansClick:) name:@"ATTENTIONFANS" object:nil];
    
}

#pragma mark request

- (void)refreshinit{
    [self.tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self refreshGetFans];
    }]];
    [self.tableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self refreshGetFans];
    }]];
}

- (void)refreshGetFans{
    [FansDataModel getFansDataWithFrendid:_frendid WithLimit:_limit handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:msg];
        }else {
            LimitResultModel *limitModel = [LimitResultModel new];
            limitModel = object;
            if (_limit == 0) {
                _members = [limitModel.result mutableCopy];
            } else {
                
                NSMutableArray *temArray = [_members mutableCopy];
                [temArray addObjectsFromArray:limitModel.result];
            }
            if (_members.count == 0) {
                _tableView.hidden = YES;
            } else {
                _tableView.hidden = NO;
            }
            [self.tableView reloadData];
            BOOL haveMore = limitModel.haveMore;
            if (haveMore) {
                _limit = limitModel.limit;
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

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FansListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fansListCell" forIndexPath:indexPath];
    FansDataModel *fansModel = _members[indexPath.row];
    cell.nicknameLabel.text = fansModel.nickname;
    [cell.otherHeadImageView.layer setCornerRadius:20.0];
    [cell.otherHeadImageView setClipsToBounds:YES];
    [cell.otherHeadImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:fansModel.portrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    switch ([fansModel.flag intValue]) {
        case 1:
            cell.fansButton.hidden = NO;
            [cell.fansButton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
            break;
        case 2:
            cell.fansButton.hidden = NO;
            [cell.fansButton setBackgroundImage:[UIImage imageNamed:@"each_attention"] forState:UIControlStateNormal];
            break;
        case 3:
            cell.fansButton.hidden = NO;
            [cell.fansButton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
            break;
        case 4:
            cell.fansButton.hidden = NO;
            [cell.fansButton setBackgroundImage:[UIImage imageNamed:@"is_attention"] forState:UIControlStateNormal];
                break;
        case 5:
            cell.fansButton.hidden = YES;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationViewController *informationVc=[[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
    FansDataModel *fansModel = _members[indexPath.row];
    informationVc.friendid = fansModel.id;
    [self.navigationController pushViewController:informationVc animated:YES];
}

#pragma mark notify

- (void)attentionFansClick:(NSNotification *)notify{
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)notify.object];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FansDataModel *fansModel = _members[indexPath.row];
    if ([fansModel.flag intValue] == 3) {
        [AddAttentionModel addAttentionWithfrendid:fansModel.id handler:^(id object, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (msg) {
                [RBNoticeHelper showNoticeAtViewController:self msg:msg];
            }else {
                fansModel.flag = @"2";
                [_members replaceObjectAtIndex:indexPath.row withObject:fansModel];
                [_tableView reloadData];
            }
        }];

    } else {
        [AddAttentionModel cancelAttentionWithFriendId:fansModel.id handler:^(id object, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (msg) {
                [RBNoticeHelper showNoticeAtViewController:self msg:msg];
            } else {
                fansModel.flag = @"3";
                [_members replaceObjectAtIndex:indexPath.row withObject:fansModel];
                [_tableView reloadData];
            }
        }];
    }
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
