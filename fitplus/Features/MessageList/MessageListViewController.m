//
//  MessageListViewController.m
//  fitplus
//
//  Created by 陈 on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageUnreadCommentModel.h"
#import "MessageCommentModel.h"
#import "UserMessageTableViewCell.h"
#import "RBNoticeHelper.h"
#import "LimitResultModel.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>
#import <MJRefresh.h>
#import "Util.h"
#import "InformationViewController.h"
#import "KDTabbarProtocol.h"
#import "ClockInDetailViewController.h"

#define VIEW_SIZE_WIDTH  [UIScreen mainScreen].bounds.size.width
#define VIEW_SIZE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MessageListViewController ()<UITableViewDelegate, UITableViewDataSource, KDTabbarProtocol>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageNumconstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *noMessageImageView;
@property (weak, nonatomic) IBOutlet UILabel *unReadMessageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageConstraint;
@property (copy, nonatomic) NSMutableArray *members;
@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self initRefrsh];
//    [self refreshMessageData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [self refreshMessageData];
    _unReadMessageLabel.hidden = YES;
    [MessageUnreadCommentModel unreadMessage:^(MessageUnreadCommentModel *object, NSString *msg) {
        _unReadMessageLabel.text = object.favorite_num;
        if (![object.favorite_num intValue] == 0) {
            _unReadMessageLabel.hidden = NO;
        } else {
            if ([object.favorite_num intValue] < 10) {
                _messageNumconstraint.constant = 22;
            }else {
                _messageNumconstraint.constant = 32;
            }
        }
    }];
}

#pragma mark request

- (void)initRefrsh{
    [self.tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self refreshMessageData];
        
    }]];
    [self.tableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self refreshMessageData];
    }]];
}

- (void)refreshMessageData{
    [MessageCommentModel MessageCommentWithLimit:_limit handler:^(id object, NSString *msg) {
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
            _noMessageImageView.hidden = NO;
        }else {
            _tableView.hidden = NO;
            _noMessageImageView.hidden = YES;
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
    MessageCommentModel *messageCommentModel = _members[indexPath.row];
    [cell.InfoHeadImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:messageCommentModel.userportrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
    [cell.InfoNIcknameButton setTitle:messageCommentModel.username forState:UIControlStateNormal];
    NSArray *dateAndtiemArray = [messageCommentModel.trendscommenttime componentsSeparatedByString:@" "];
    NSArray *dataArray = [dateAndtiemArray[0] componentsSeparatedByString:@"-"];
    NSArray *timeArray = [dateAndtiemArray[1] componentsSeparatedByString:@":"];
    cell.InfoMessageTimeLabel.text = [NSString stringWithFormat:@"%@-%@ %@:%@",dataArray[1],dataArray[2],timeArray[0],timeArray[1]];
    if ([messageCommentModel.trendstype intValue] == 1) {
        cell.InfoMessageLabel.text = messageCommentModel.trendscommentcontent;
        cell.messageLabel.hidden = YES;
        [cell.messageImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:messageCommentModel.trendphoto]]];
    }else {
        cell.messageImageView.hidden = YES;
        cell.InfoMessageLabel.text = messageCommentModel.cpartakcontent;
        cell.messageLabel.text = messageCommentModel.trendscommentcontent;
    }
    if ([messageCommentModel.isread intValue] == 1) {
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
    MessageCommentModel *messageCommentModel = _members[indexPath.row];
    CGSize labelSize = [messageCommentModel.trendscommentcontent boundingRectWithSize:CGSizeMake(VIEW_SIZE_WIDTH - 148, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
    if (labelSize.height > 15) {
        return 76;
    } else {
        return 62;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClockInDetailViewController *clockInDetailVc = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
    MessageCommentModel *messageModel = _members[indexPath.row];
    clockInDetailVc.clockinId =messageModel.trendid;
    [self.navigationController pushViewController:clockInDetailVc animated:YES];
    messageModel.isread = @"2";
    [_members replaceObjectAtIndex:indexPath.row withObject:messageModel];
    [_tableView reloadData];
}

#pragma mark buttonClick

- (IBAction)goToInformationClick:(UIButton *)sender {
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    InformationViewController *informationVc=[[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
    MessageCommentModel *messageModel = _members[indexPath.row];
    informationVc.friendid = messageModel.userid;
    [self.navigationController pushViewController:informationVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabbar
- (UIView *)titleViewForTabbarNav {
    return nil;
}

- (NSString *)titleForTabbarNav {
    return @"消息";
}

-(NSArray *)leftButtonsForTabbarNav {
    return nil;
}
- (NSArray *)rightButtonsForTabbarNav{
    return nil;
}


@end
