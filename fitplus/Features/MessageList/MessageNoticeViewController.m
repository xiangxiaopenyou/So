//
//  MessageNoticeViewController.m
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessageNoticeViewController.h"
#import "MessagePraiseModel.h"
#import "UserMessageTableViewCell.h"
#import "RBNoticeHelper.h"
#import "LimitResultModel.h"
#import "Util.h"
#import "ClockInDetailViewController.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>
#import <MJRefresh.h>
#import "InformationViewController.h"
#define imageUrlStr @"http://7u2h8u.com1.z0.glb.clouddn.com/"

@interface MessageNoticeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *members;

@end

@implementation MessageNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefrsh];
    [self refreshMessageData];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark request

- (void)initRefrsh{
    [self.tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self refreshMessageData];
    }]];
    [self.tableView setFooter:[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self refreshMessageData];
    }]];
}

- (void)refreshMessageData{
    [MessagePraiseModel MessagePraiseWithLimit:_limit handler:^(id object, NSString *msg) {
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
        if (_members.count == 0) {
            _tableView.hidden = YES;
        }else{
            _tableView.hidden = NO;
        }
    }];
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UserMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userMessageCell" forIndexPath:indexPath];
    MessagePraiseModel *messagePraiseModel = _members[indexPath.row];
    [cell.InfoHeadImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:messagePraiseModel.userportrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    [cell.InfoNIcknameButton setTitle:messagePraiseModel.username forState:UIControlStateNormal];
    NSArray *dateAndtiemArray = [messagePraiseModel.favoritetime componentsSeparatedByString:@" "];
    NSArray *dataArray = [dateAndtiemArray[0] componentsSeparatedByString:@"-"];
    NSArray *timeArray = [dateAndtiemArray[1] componentsSeparatedByString:@":"];
    cell.InfoMessageTimeLabel.text = [NSString stringWithFormat:@"%@－%@ %@:%@",dataArray[1],dataArray[2],timeArray[0],timeArray[1]];
    //cell.InfoMessageLabel.text = ;
    //[cell.messageImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:messagePraiseModel.trendphoto]]];
    if ([messagePraiseModel.type isEqualToString:@"fans"]) {
        cell.InfoMessageLabel.text = @"关注了您";
    }else {
        cell.InfoMessageLabel.text = @"给您加了油";
    }
    if ([messagePraiseModel.isread intValue] == 1) {
        cell.isReadLabel.hidden = NO;
    }else {
        cell.isReadLabel.hidden = YES;
    }
    if (indexPath.row == _members.count-1) {
        cell.lineLabel.hidden = YES;
    }else {
        cell.lineLabel.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessagePraiseModel *messageModel = _members[indexPath.row];
    if ([messageModel.type isEqual:@"fans"]) {
        InformationViewController *informationVc=[[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
        informationVc.friendid = messageModel.userid;
        [self.navigationController pushViewController:informationVc animated:YES];
    }else {
        ClockInDetailViewController *clockInDetailVc = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
        clockInDetailVc.clockinId =messageModel.trendid;
        [self.navigationController pushViewController:clockInDetailVc animated:YES];
    }
    messageModel.isread = @"2";
    [_members replaceObjectAtIndex:indexPath.row withObject:messageModel];
    [_tableView reloadData];
}

#pragma mark buttonClick

- (IBAction)goToInformationClick:(UIButton *)sender {
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    InformationViewController *informationVc=[[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
    MessagePraiseModel *messageModel = _members[indexPath.row];
    informationVc.friendid = messageModel.userid;
    [self.navigationController pushViewController:informationVc animated:YES];
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

@end
