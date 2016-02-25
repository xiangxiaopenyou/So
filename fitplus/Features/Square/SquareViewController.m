//
//  SquareViewController.m
//  fitplus
//
//  Created by xlp on 15/7/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SquareViewController.h"
#import "CommonsDefines.h"
#import "TodayRecommendationCell.h"
#import "PopularUserCell.h"
#import "AttentionClockinContentCell.h"
#import "TopicCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ClockInDetailModel.h"
#import "LimitResultModel.h"
#import "KDTabbarProtocol.h"
#import "RecommendationModel.h"
#import "ClockInDetailViewController.h"
#import "ActivityWebViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"
#import "TopicMoreClockInViewController.h"
#import "TodayRecommendationListViewController.h"
#import "AppDelegate.h"
#import "RBBlockActionSheet.h"
#import "AddFriendsViewController.h"
#import "InformationViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UserInfo.h"

@interface SquareViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, AttentionClockInDelegate, KDTabbarProtocol>

@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) CGPoint lastPoint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewForTableConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *recommendationTableConstraint;
@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) NSMutableArray *friendsClockInArray;
@property (strong, nonatomic) NSMutableArray *recommendedPictureArray;
@property (strong, nonatomic) NSMutableArray *recommendedUserArray;
@property (strong, nonatomic) NSMutableArray *topicArray;
@property (strong, nonatomic) NSMutableArray *activitiesArray;
@property (assign, nonatomic) BOOL isViewLoad;
@property (strong, nonatomic) UIView *tipView;

@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    _currentIndex = 1;
    _recommendationTableView.tableHeaderView.frame = CGRectMake(0, 0, 0, SCREEN_WIDTH/2);
    _topScrollView.delegate = self;
    
    UIPanGestureRecognizer *recommendationPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGestureRecognizer:)];
    recommendationPanGR.delegate = self;
    [_recommendationTableView addGestureRecognizer:recommendationPanGR];
    
    UIPanGestureRecognizer *attentionPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGestureRecognizer:)];
    attentionPanGR.delegate = self;
    [_attentionTableView addGestureRecognizer:attentionPanGR];
    _attentionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIPanGestureRecognizer *topicPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGestureRecognizer:)];
    topicPanGR.delegate = self;
    [_topicTableView addGestureRecognizer:topicPanGR];
    _topicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initRefersh];
    
    _isViewLoad = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:IsFirstOpenTool] integerValue] == 1) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tipView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:_tipView];
        UIButton *knowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        knowButton.frame = CGRectMake(SCREEN_WIDTH/2 - 42, SCREEN_HEIGHT - 300, 84, 32);
        [knowButton setBackgroundImage:[UIImage imageNamed:@"guide_button"] forState:UIControlStateNormal];
        [knowButton addTarget:self action:@selector(knownButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_tipView addSubview:knowButton];
        
        UIImageView *tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 112, SCREEN_HEIGHT - 240, 224, 190)];
        tipImage.image = [UIImage imageNamed:@"guide_tool"];
        [_tipView addSubview:tipImage];
    }
    
    self.recommendationTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.recommendationTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _limit = 0;
    [self fetchActivities];
    [self fetchRecommendationContent];
    [self fetchFriendsClockIn];
    [self fetchTopicList];
    
}
- (void)knownButtonClick {
    [_tipView removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:IsFirstOpenTool];
}
- (void)initRefersh {
    [_attentionTableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self fetchFriendsClockIn];
    }]];
    [_attentionTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchFriendsClockIn];
    }]];
}
- (void)fetchActivities {
    [RecommendationModel fetchActivities:^(id object, NSString *msg) {
        if (!msg) {
            _activitiesArray = [object mutableCopy];
            if (_isViewLoad) {
                [self addImageToScrollView:_activitiesArray];
                _isViewLoad = NO;
            }
        }
    }];
}
- (void)fetchRecommendationContent {
    [RecommendationModel fetchRecommendationContent:^(id object, NSString *msg) {
        if (msg) {
            NSLog(@"获取推荐失败");
        } else {
            NSMutableArray *tempArray = [object mutableCopy];
            NSDictionary *tempDictionary = object[0];
            _recommendedPictureArray = [tempDictionary[@"trend_data"] mutableCopy];
            _recommendedUserArray = [[tempArray subarrayWithRange:NSMakeRange(1, tempArray.count - 1)]  mutableCopy];
            [_recommendationTableView reloadData];
        }
    }];
}
- (void)fetchFriendsClockIn {
    [ClockInDetailModel fetchFriendsClockIn:_limit handler:^(id object, NSString *msg) {
        [_attentionTableView.header endRefreshing];
        [_attentionTableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *model = [LimitResultModel new];
            model = object;
            if (_limit == 0) {
                _friendsClockInArray = [model.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_friendsClockInArray mutableCopy];
                [tempArray addObjectsFromArray:model.result];
                _friendsClockInArray = tempArray;
            }
            [_attentionTableView reloadData];
            BOOL haveMore = model.haveMore;
            if (haveMore) {
                _limit = model.limit;
                _attentionTableView.footer.hidden = NO;
            } else {
                [_attentionTableView.footer noticeNoMoreData];
                _attentionTableView.footer.hidden = YES;
            }
        }
       
    }];
}
- (void)fetchTopicList {
    [RecommendationModel fetchTopicList:^(id object, NSString *msg) {
        if (!msg) {
            _topicArray = [object mutableCopy];
            [_topicTableView reloadData];
        }
    }];
}

- (void)addImageToScrollView:(NSArray *)imageArray {
    _pageControl.numberOfPages = imageArray.count;
    _pageControl.currentPage = 0;
    for (int i = 0; i < imageArray.count; i ++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(_topScrollView.frame), 0, CGRectGetWidth(_topScrollView.frame), CGRectGetHeight(_topScrollView.frame))];
        //image.contentMode = uiview;
        image.clipsToBounds = YES;
        image.tag = i;
        image.userInteractionEnabled = YES;
        [image setImageWithURL:[NSURL URLWithString:[Util urlPhoto:imageArray[i][@"title"]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusImagePress:)]];
        [_topScrollView addSubview:image];
    }
    _topScrollView.contentSize = CGSizeMake(CGRectGetWidth(_topScrollView.frame) * imageArray.count, 0);
}

- (void)handlerPanGestureRecognizer:(UIPanGestureRecognizer *)panGR{
    if (panGR.state == UIGestureRecognizerStateEnded) {
        _lastPoint = CGPointZero;
        if (_viewForTableConstraint.constant >= 0 || _viewForTableConstraint.constant <= -1 * SCREEN_WIDTH * 2) {
            return;
        }
        CGPoint velocity = [panGR velocityInView:self.view];
        _viewForTableConstraint.constant += velocity.x / 20;
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                         } completion:^(BOOL finished) {
                             CGFloat pageIndex = (-1 * _viewForTableConstraint.constant / SCREEN_WIDTH);
                             if (pageIndex < 0.5) {
                                 [self recommendationButtonClick:nil];
                             } else if (pageIndex < 1.5) {
                                 [self attentionButtonClick:nil];
                             } else {
                                 [self topicButtonClick:nil];
                             }
                         }];
        return;
    }
    CGPoint point = [panGR locationInView:self.view];
    if (panGR.state == UIGestureRecognizerStateBegan) {
        _lastPoint = point;
        return;
    }
    NSInteger changeX = point.x - _lastPoint.x;
    float newConstraintValue = _viewForTableConstraint.constant + changeX;
    if (newConstraintValue > 0) {
        newConstraintValue = 0;
    } else if (newConstraintValue < -1 * SCREEN_WIDTH * 2) {
        newConstraintValue = -1 * SCREEN_WIDTH * 2;
    }
    _viewForTableConstraint.constant = newConstraintValue;
    _lastPoint = point;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];
    if (fabs(translation.x) > fabs(translation.y)) {
        return YES;
    }
    
    return NO;
}

#pragma mark - FocusImage
- (void)focusImagePress:(UITapGestureRecognizer *)gesture {
    UIImageView *image = (UIImageView *)gesture.view;
    NSDictionary *tempDictionary = [_activitiesArray objectAtIndex:image.tag];
    ActivityWebViewController *activityViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ActivityWebView"];
    activityViewController.urlString = tempDictionary[@"url"];
    [self.navigationController pushViewController:activityViewController animated:YES];
}


#pragma mark - UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _recommendationTableView) {
        return 2;
    } else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber = 0;
    if (tableView == _recommendationTableView) {
        if (section == 0) {
            rowNumber = 1;
        } else {
            rowNumber = _recommendedUserArray.count;
        }
    } else if (tableView == _attentionTableView) {
        rowNumber = _friendsClockInArray.count;
    } else {
        rowNumber = _topicArray.count;
    }
    return rowNumber;
   
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, 100, 29)];
    headerLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    headerLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:headerLabel];
    
    if (tableView == _recommendationTableView) {
        switch (section) {
            case 0:{
                headerLabel.text = @"今日推荐";
                UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, 8.5, 22, 22)];
                rightImage.image = [UIImage imageNamed:@"cell_right"];
                [headerView addSubview:rightImage];
                UIButton *moreRecommendationButton = [UIButton buttonWithType:UIButtonTypeCustom];
                moreRecommendationButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
                [moreRecommendationButton addTarget:self action:@selector(moreRecommendationClick) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:moreRecommendationButton];
            }
                break;
            case 1:{
                headerLabel.text = @"热门用户";
            }
            default:
                break;
        }
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _recommendationTableView) {
        if (section == 0 || section == 1) {
            return 35;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float rowHeight = 0;
    if (tableView == _recommendationTableView) {
        switch (indexPath.section) {
            case 0:
                rowHeight = SCREEN_WIDTH/3 + 15;
                break;
            case 1:
                rowHeight = SCREEN_WIDTH/3 + 56;
            default:
                break;
        }
    } else if (tableView == _attentionTableView) {
        rowHeight = [[AttentionClockinContentCell new] cellHeightWithDic:[_friendsClockInArray objectAtIndex:indexPath.row]];
        //rowHeight = 200 + SCREEN_WIDTH;
    } else {
        rowHeight = SCREEN_WIDTH/3 + 45;
    }
    return rowHeight;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _recommendationTableView) {
        static NSString *TodayCell = @"TodayRecommendationCell";
        static NSString *PopularCell = @"PopularUserCell";
        switch (indexPath.section) {
            case 0:{
                TodayRecommendationCell *cell = [tableView dequeueReusableCellWithIdentifier:TodayCell forIndexPath:indexPath];
                [cell setupWithImageDic:_recommendedPictureArray];
                [cell clickImage:^(NSInteger index) {
                    ClockInDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
                    if (index == 1) {
                        detailViewController.clockinId = _recommendedPictureArray[0][@"trendsid"];
                    } else if (index == 2) {
                        detailViewController.clockinId = _recommendedPictureArray[1][@"trendsid"];
                        
                    } else {
                        detailViewController.clockinId = _recommendedPictureArray[2][@"trendsid"];
                    }
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 1:{
                PopularUserCell *cell = [tableView dequeueReusableCellWithIdentifier:PopularCell forIndexPath:indexPath];
                NSDictionary *tempDic = [_recommendedUserArray objectAtIndex:indexPath.row];
                [cell setupCellContent:tempDic];
                //NSDictionary *tempDic = [_recommendedUserArray objectAtIndex:indexPath.row];
                NSArray *tempArray = tempDic[@"trend_data"];
                [cell clickImage:^(NSInteger index) {
                    ClockInDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
                    if (index == 1) {
                        detailViewController.clockinId = tempArray[0][@"trendsid"];
                    } else if (index == 2) {
                        detailViewController.clockinId = tempArray[1][@"trendsid"];
                    } else {
                        detailViewController.clockinId = tempArray[2][@"trendsid"];
                    }
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }];
                [cell clickAttention:^(BOOL isClick) {
                    if (isClick) {
                        [self fetchRecommendationContent];
                    }
                }];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            default:
                return nil;
                break;
        }

    } else if (tableView == _attentionTableView) {
        static NSString *ClockinCell = @"ClockinContentCell";
        AttentionClockinContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ClockinCell forIndexPath:indexPath];
        [cell setupCellViewWithDic:[_friendsClockInArray objectAtIndex:indexPath.row]];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *TopicCellIdentifier = @"TopicCell";
        TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellIdentifier forIndexPath:indexPath];
        if (_topicArray.count  > 0) {
            [cell setupWithDic:[_topicArray objectAtIndex:indexPath.row]];
            [cell clickImage:^(NSInteger index) {
                NSDictionary *tempDictionary = [_topicArray objectAtIndex:indexPath.row];
                NSArray *tempArray = tempDictionary[@"trend_data"];
                ClockInDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
                if (index == 1) {
                    detailViewController.clockinId = tempArray[0][@"trendsid"];
                } else if (index == 2) {
                    detailViewController.clockinId = tempArray[1][@"trendsid"];
                } else {
                    detailViewController.clockinId = tempArray[2][@"trendsid"];
                }
                [self.navigationController pushViewController:detailViewController animated:YES];
                
            }];

        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _attentionTableView) {
        ClockInDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
        ClockInDetailModel *model = [_friendsClockInArray objectAtIndex:indexPath.row];
        //ClockInDetailViewController *detailVC = [[ClockInDetailViewController alloc] init];
        detailVC.clockinId = model.id;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (tableView == _topicTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary *tempDic = [_topicArray objectAtIndex:indexPath.row];
        TopicMoreClockInViewController *moreViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"MoreClockInView"];
        moreViewController.topicId = tempDic[@"id"];
        moreViewController.topicTitle = tempDic[@"name"];
        [self.navigationController pushViewController:moreViewController animated:YES];
    } else {
        if (indexPath.section == 1) {
            NSDictionary *tempDic = [_recommendedUserArray objectAtIndex:indexPath.row];
            InformationViewController *informationViewController = [[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
            informationViewController.friendid = tempDic[@"userid"];
            [self.navigationController pushViewController:informationViewController animated:YES];
        }
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    //_pageControl.currentPage = floor(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)moreRecommendationClick {
        TodayRecommendationListViewController *todayRecommendationViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayRecommendationView"];
        [self.navigationController pushViewController:todayRecommendationViewController animated:YES];
}

- (IBAction)recommendationButtonClick:(id)sender {
    _currentIndex = 1;
    _viewForTableConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        //_viewForTable.frame = CGRectMake(0, 36, SCREEN_WIDTH * 3, SCREEN_HEIGHT - 149);
        [self.view layoutIfNeeded];
        _selectedLabel.frame = CGRectMake(0, 42, SCREEN_WIDTH/3, 2);
    }];
}

- (IBAction)attentionButtonClick:(id)sender {
    _currentIndex = 2;
    _viewForTableConstraint.constant = - SCREEN_WIDTH;
    [UIView animateWithDuration:0.3 animations:^{
        //_viewForTable.frame = CGRectMake(0 - SCREEN_WIDTH, 36, SCREEN_WIDTH*3, SCREEN_HEIGHT - 149);
        [self.view layoutIfNeeded];
        _selectedLabel.frame = CGRectMake(SCREEN_WIDTH/3, 42, SCREEN_WIDTH/3, 2);
    }];
}

- (IBAction)topicButtonClick:(id)sender {
    _currentIndex = 3;
    _viewForTableConstraint.constant = - 2 * SCREEN_WIDTH;
    [UIView animateWithDuration:0.3 animations:^{
        //_viewForTable.frame = CGRectMake(0 - 2*SCREEN_WIDTH, 36, SCREEN_WIDTH * 3, SCREEN_HEIGHT - 149);
        [self.view layoutIfNeeded];
        
        _selectedLabel.frame = CGRectMake(2*SCREEN_WIDTH/3, 42, SCREEN_WIDTH/3, 2);
    }];
}

- (UIView *)titleViewForTabbarNav {
    return nil;
}

- (NSString *)titleForTabbarNav {
    return @"广场";
}

-(NSArray *)leftButtonsForTabbarNav {
    return nil;
}

- (NSArray *)rightButtonsForTabbarNav{
    UIBarButtonItem *addFriendButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_friends"] style:UIBarButtonItemStylePlain target:self action:@selector(showAddFriend)];
    return @[addFriendButton];
}

- (void)showAddFriend {
    //[self performSegueWithIdentifier:@"Square2AddFriend" sender:self];
    AddFriendsViewController *addFriendsViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"AddFriendsView"];
    [self.navigationController pushViewController:addFriendsViewController animated:YES];
}

@end
