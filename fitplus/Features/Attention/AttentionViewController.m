//
//  AttentionViewController.m
//  fitplus
//
//  Created by 陈 on 15/7/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AttentionViewController.h"
#import "AttentionDataModel.h"
#import "AttentionListTableViewCell.h"
#import "AddAttentionModel.h"
#import "RBNoticeHelper.h"
#import "LimitResultModel.h"
#import <UIImageView+AFNetworking.h>
#import "InformationViewController.h"
#import <MJRefresh.h>
#import "Util.h"
#import <MBProgressHUD.h>
#import "CommonsDefines.h"
#define imageUrlStr @"http://7u2h8u.com1.z0.glb.clouddn.com/"

@interface AttentionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSMutableArray *members;
@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self initrefresh];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADDATTENTION" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAttentionClick:) name:@"ADDATTENTION" object:nil];
    [self refreshAttentionData];
}
#pragma mark request

- (void)initrefresh{
    [_tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self refreshAttentionData];
    }]];
    [_tableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self refreshAttentionData];
    }]];
}

- (void)refreshAttentionData{
    [AttentionDataModel getAttentionDataWithFrendid:_frendid WithLimit:_limit handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:msg];
        }else {
            LimitResultModel *limitModel = [LimitResultModel new];
            limitModel = object;
            if (_limit == 0) {
                _members = [limitModel.result mutableCopy];
            }else {
                NSMutableArray *temArray = [_members mutableCopy];
                [temArray addObjectsFromArray:limitModel.result];
                _members = temArray;
            }
            if (_members.count == 0) {
                _tableView.hidden = YES;
            } else {
                _tableView.hidden = NO;
            }
            [_tableView reloadData];
            BOOL haveMore = limitModel.haveMore;
            if (haveMore) {
                _limit = limitModel.limit;
                _tableView.footer.hidden = NO;
            }else {
                [_tableView.footer noticeNoMoreData];
                _tableView.footer.hidden = YES;
            }
        }
    }];
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _members.count; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attentionListCell" forIndexPath:indexPath];
    AttentionDataModel *attentionModel = _members[indexPath.row];
    cell.nicknameLabel.text = attentionModel.nickname;
    [cell.otherHeadImageView.layer setCornerRadius:20.0];
    [cell.otherHeadImageView setClipsToBounds:YES];
    [cell.otherHeadImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:attentionModel.portrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    switch ([attentionModel.flag intValue]) {
        case 1:
            cell.attentionbutton.hidden = NO;
            [cell.attentionbutton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
            break;
        case 2:
            cell.attentionbutton.hidden = NO;
            [cell.attentionbutton setBackgroundImage:[UIImage imageNamed:@"each_attention"] forState:UIControlStateNormal];
            break;
        case 3:
            cell.attentionbutton.hidden = NO;
            [cell.attentionbutton setBackgroundImage:[UIImage imageNamed:@"add_attention"] forState:UIControlStateNormal];
            break;
        case 4:
            cell.attentionbutton.hidden = NO;
            [cell.attentionbutton setBackgroundImage:[UIImage imageNamed:@"is_attention"] forState:UIControlStateNormal];
            break;
        case 5:
            cell.attentionbutton.hidden = YES;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationViewController *informationVc=[[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
    AttentionDataModel *attentionModel = _members[indexPath.row];
    informationVc.friendid = attentionModel.id;
    [self.navigationController pushViewController:informationVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark notify

- (void)addAttentionClick:(NSNotification *)notity{
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)notity.object];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AttentionDataModel *attentionModel = _members[indexPath.row];
    switch ([attentionModel.flag intValue]) {
        case 1:{
            [AddAttentionModel addAttentionWithfrendid:attentionModel.id handler:^(id object, NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (msg) {
                    [RBNoticeHelper showNoticeAtViewController:self msg:msg];
                } else {
                    attentionModel.flag = @"4";
                    [_members replaceObjectAtIndex:indexPath.row withObject:attentionModel];
                    [_tableView reloadData];
                }
            }];
        }
            break;
        case 2:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AddAttentionModel cancelAttentionWithFriendId:attentionModel.id handler:^(id object, NSString *msg) {
                if (msg) {
                    [RBNoticeHelper showNoticeAtViewController:self msg:msg];
                } else {
                    attentionModel.flag = @"3";
                    [_members replaceObjectAtIndex:indexPath.row withObject:attentionModel];
                    [_tableView reloadData];
                }
            }];
        }
            break;
        case 3:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AddAttentionModel addAttentionWithfrendid:attentionModel.id handler:^(id object, NSString *msg) {
                if (msg) {
                    [RBNoticeHelper showNoticeAtViewController:self msg:msg];
                } else {
                    attentionModel.flag = @"2";
                    [_members replaceObjectAtIndex:indexPath.row withObject:attentionModel];
                    [_tableView reloadData];
                }
            }];
        }
            break;
        case 4:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AddAttentionModel cancelAttentionWithFriendId:attentionModel.id handler:^(id object, NSString *msg) {
                if (msg) {
                    [RBNoticeHelper showNoticeAtViewController:self msg:msg];
                } else {
                    attentionModel.flag = @"1";
                    [_members replaceObjectAtIndex:indexPath.row withObject:attentionModel];
                    [_tableView reloadData];
                }
            }];
        }
            break;
        default:
            break;
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
