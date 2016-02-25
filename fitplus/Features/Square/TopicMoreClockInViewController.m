//
//  TopicMoreClockInViewController.m
//  fitplus
//
//  Created by xlp on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TopicMoreClockInViewController.h"
#import "RecommendationModel.h"
#import "AttentionClockinContentCell.h"
#import <MJRefresh/MJRefresh.h>
#import "LimitResultModel.h"
#import "ClockInDetailViewController.h"
#import "AppDelegate.h"
#import "RBBlockActionSheet.h"
#import "Util.h"
#import "InformationViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface TopicMoreClockInViewController ()<UITableViewDataSource, UITableViewDelegate, AttentionClockInDelegate>
@property (strong, nonatomic) IBOutlet UITableView *clockInTableView;
@property (strong, nonatomic) NSMutableArray *clockInArray;
@property (assign, nonatomic) NSInteger limit;

@end

@implementation TopicMoreClockInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _topicTitle;
    _clockInTableView.tableFooterView = [UIView new];
    _limit = 0;
    [self initRefresh];
    [self fetchData];
}
- (void)initRefresh {
    [_clockInTableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self fetchData];
    }]];
    [_clockInTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchData];
    }]];
}
- (void)fetchData {
    [RecommendationModel fetchMoreClockInOfTopic:_topicId handler:^(id object, NSString *msg) {
        [_clockInTableView.header endRefreshing];
        [_clockInTableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *model = [LimitResultModel new];
            model = object;
            if (_limit == 0) {
                _clockInArray = [model.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_clockInArray mutableCopy];
                [tempArray addObjectsFromArray:model.result];
                _clockInArray = tempArray;
            }
            [_clockInTableView reloadData];
            BOOL haveMore = model.haveMore;
            if (haveMore) {
                _limit = model.limit;
                _clockInTableView.footer.hidden = NO;
            } else {
                [_clockInTableView.footer noticeNoMoreData];
                _clockInTableView.footer.hidden = YES;
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
    return _clockInArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[AttentionClockinContentCell new] cellHeightWithDic:_clockInArray[indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ClockInCell = @"ClockinContentCell";
    AttentionClockinContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ClockInCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AttentionClockinContentCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ClockInCell];
    }
    [cell setupCellViewWithDic:[_clockInArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClockInDetailModel *tempModel = [_clockInArray objectAtIndex:indexPath.row];
    ClockInDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
    detailViewController.clockinId = tempModel.id;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - AttentionClockInDelegate
- (void)clickComment:(NSString *)trendId {
    ClockInDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
    detailViewController.isCommentIn = YES;
    detailViewController.clockinId = trendId;
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (void)clickShare:(ClockInDetailModel *)model image:(UIImage *)image {
    if (!image) {
        image = [UIImage imageNamed:@"share_default"];
    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@trendId=%@&f=ios", NewBaseApiURL, CommonShareUrl, model.id];
    id<ISSContent> publishContent = [ShareSDK content:model.clockinContent
                                       defaultContent:@"一起健身吧"
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@"健身坊，让健身更简单~"
                                                  url:shareUrl
                                          description:model.clockinContent
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    NSArray *shareList = [ShareSDK getShareListWithType: /*ShareTypeSinaWeibo, ShareTypeQQSpace, ShareTypeQQ,*/ ShareTypeWeixiSession, ShareTypeWeixiTimeline,nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess) {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                } else if (state == SSResponseStateFail) {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
- (void)clickHeadPortrait:(NSString *)userid {
    InformationViewController *informationViewController = [[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
    informationViewController.friendid = userid;
    [self.navigationController pushViewController:informationViewController animated:YES];
    
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
