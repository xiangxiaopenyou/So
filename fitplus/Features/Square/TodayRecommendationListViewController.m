//
//  TodayRecommendationListViewController.m
//  fitplus
//
//  Created by xlp on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TodayRecommendationListViewController.h"
#import "RecommendationModel.h"
#import "LimitResultModel.h"
#import "AttentionClockinContentCell.h"
#import "ClockInDetailModel.h"
#import <MJRefresh/MJRefresh.h>
#import "ClockInDetailViewController.h"
#import "RBBlockActionSheet.h"
#import "Util.h"
#import "InformationViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface TodayRecommendationListViewController ()<UITableViewDataSource, UITableViewDelegate, AttentionClockInDelegate>

@property (strong, nonatomic) NSMutableArray *recommendationArray;
@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) IBOutlet UITableView *recommendationTableView;

@end

@implementation TodayRecommendationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"今日推荐";
    
    _recommendationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initRefresh];
    [self fetchRecommendationList];
    
}
- (void)initRefresh {
    [_recommendationTableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self fetchRecommendationList];
    }]];
    [_recommendationTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchRecommendationList];
    }]];
}
- (void)fetchRecommendationList {
    [RecommendationModel fetchTodayRecommendation:_limit handler:^(id object, NSString *msg) {
        [_recommendationTableView.header endRefreshing];
        [_recommendationTableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *limitModel = [LimitResultModel new];
            limitModel = object;
            if (_limit == 0) {
                _recommendationArray = [limitModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_recommendationArray mutableCopy];
                [tempArray addObjectsFromArray:limitModel.result];
                _recommendationArray = tempArray;
            }
            [_recommendationTableView reloadData];
            BOOL haveMore = limitModel.haveMore;
            if (haveMore) {
                _limit = limitModel.limit;
                _recommendationTableView.footer.hidden = NO;
            } else {
                [_recommendationTableView.footer noticeNoMoreData];
                _recommendationTableView.footer.hidden = YES;
            }
        } 
       
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recommendationArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[AttentionClockinContentCell new] cellHeightWithDic:_recommendationArray[indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *RecommendationCell = @"ClockinContentCell";
    AttentionClockinContentCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendationCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AttentionClockinContentCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:RecommendationCell];
    }
    [cell setupCellViewWithDic:[_recommendationArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClockInDetailModel *tempModel = [_recommendationArray objectAtIndex:indexPath.row];
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
