//
//  DrysalteryListViewController.m
//  fitplus
//
//  Created by xlp on 15/8/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DrysalteryListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "CommonsDefines.h"
#import "DrysalteryCell.h"
#import "KDTabbarProtocol.h"
#import "DrysalteryModel.h"
#import "LimitResultModel.h"
#import "DrysalterDetailViewController.h"
#import <MBProgressHUD.h>
#import "CourseCell.h"
#import "CourseModel.h"
#import "MyCourseCell.h"
#import "MoreCourseViewController.h"
#import "CourseDetailViewController.h"
#import <MBProgressHUD.h>
#import "UserInfo.h"

@interface DrysalteryListViewController ()<UITableViewDataSource, UITableViewDelegate, KDTabbarProtocol>
@property (weak, nonatomic) IBOutlet UITableView *drysalteryTableView;
@property (weak, nonatomic) IBOutlet UITableView *courseTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) NSMutableArray *drysalteryArray;
@property (weak, nonatomic) IBOutlet UILabel *todayEnergyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewForTableLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *myDataView;
@property (weak, nonatomic) IBOutlet UILabel *rankBar;
@property (weak, nonatomic) IBOutlet UILabel *currentRankBar;
@property (weak, nonatomic) IBOutlet UIImageView *rank1Image;
@property (weak, nonatomic) IBOutlet UIImageView *rank2Image;
@property (weak, nonatomic) IBOutlet UIImageView *rank3Image;
@property (weak, nonatomic) IBOutlet UIView *upgradeView;
@property (weak, nonatomic) IBOutlet UILabel *upgradeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentEnergyWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *rank2Label;
@property (weak, nonatomic) IBOutlet UILabel *rank3Label;
@property (weak, nonatomic) IBOutlet UILabel *trainingDaysLabel;
@property (strong, nonatomic) UIView *guideTipView;

@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, assign) BOOL isMyCourse;
@property (nonatomic, strong) NSMutableArray *courseArray;

@end

@implementation DrysalteryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _segmentIndex = 0;
    
    [self initRefresh];
    [self setupHeaderView];
    _limit = 0;
    
    if ([self checkIfLogin]) {
        
    } else {
        [self showLogin];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fetchDryList];
    [self fetchMyData];
    [self fetchCourseList];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:IsNewUserKey] integerValue] == 0) {
        [self setupGuideTipView];
    }
}
- (void)setupHeaderView {
    _rankBar.layer.masksToBounds = YES;
    _rankBar.layer.cornerRadius = 2.0;
    _currentRankBar.layer.masksToBounds = YES;
    _currentRankBar.layer.cornerRadius = 2.0;
    _upgradeView.layer.masksToBounds = YES;
    _upgradeView.layer.cornerRadius = 2.0;
    _rank1Image.highlighted = YES;
}
- (void)setupGuideTipView {
    _guideTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _guideTipView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 130, SCREEN_HEIGHT / 2 - 152, 260, 304)];
    containView.backgroundColor = [UIColor whiteColor];
    containView.layer.masksToBounds = YES;
    containView.layer.cornerRadius = 4.0;
    [_guideTipView addSubview:containView];
    
    UILabel *helloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 260, 18)];
    helloLabel.font = [UIFont systemFontOfSize:15];
    helloLabel.textColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1.0];
    helloLabel.textAlignment = NSTextAlignmentCenter;
    NSString *nicknameString = [[NSUserDefaults standardUserDefaults] stringForKey:UserName];
    helloLabel.text = [NSString stringWithFormat:@"Hi,%@", nicknameString];
    [containView addSubview:helloLabel];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 260, 18)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1.0];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"欢迎来到So,";
    [containView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, 220, 18)];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1.0];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"告诉我你的身体状况，让我来给";
    label2.numberOfLines = 0;
    label2.lineBreakMode = NSLineBreakByCharWrapping;
    [containView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 86, 260, 18)];
    label3.font = [UIFont systemFontOfSize:15];
    label3.textColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1.0];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"你制定专属的训练方案吧！";
    label3.lineBreakMode = NSLineBreakByCharWrapping;
    [containView addSubview:label3];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(85, 135, 90, 90)];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 45.0;
    NSInteger sexInt = [[NSUserDefaults standardUserDefaults] integerForKey:UserSex];
    if (sexInt == 1) {
        headImage.image = [UIImage imageNamed:@"bg_coachmale"];
    } else {
        headImage.image = [UIImage imageNamed:@"bg_coachfemale"];
    }
    [containView addSubview:headImage];
    
    UIButton *cancelTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelTipButton.frame = CGRectMake(14, 250, 110, 44);
    [cancelTipButton setTitle:@"我先看看" forState:UIControlStateNormal];
    [cancelTipButton setTitleColor:[UIColor colorWithRed:77/255.0 green:62/255.0 blue:93/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancelTipButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelTipButton.layer.masksToBounds = YES;
    cancelTipButton.layer.cornerRadius = 2.0;
    cancelTipButton.layer.borderWidth = 0.5;
    cancelTipButton.layer.borderColor = [UIColor colorWithRed:77/255.0 green:62/255.0 blue:93/255.0 alpha:1.0].CGColor;
    cancelTipButton.backgroundColor = [UIColor whiteColor];
    cancelTipButton.tag = 98;
    [cancelTipButton addTarget:self action:@selector(tipGuideButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:cancelTipButton];
    
    UIButton *tellCoachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tellCoachButton.frame = CGRectMake(136, 250, 110, 44);
    [tellCoachButton setTitle:@"告诉教练" forState:UIControlStateNormal];
    [tellCoachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tellCoachButton.titleLabel.font = [UIFont systemFontOfSize:16];
    tellCoachButton.layer.masksToBounds = YES;
    tellCoachButton.layer.cornerRadius = 2.0;
    tellCoachButton.backgroundColor = [UIColor colorWithRed:77/255.0 green:62/255.0 blue:93/255.0 alpha:1.0];
    tellCoachButton.tag = 99;
    [tellCoachButton addTarget:self action:@selector(tipGuideButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:tellCoachButton];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_guideTipView];
}

- (void) initRefresh {
    [_drysalteryTableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self fetchDryList];
        
    }]];
    [_drysalteryTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchDryList];
    }]];
}
- (void)fetchCourseList {
    [CourseModel fetchMyCourse:1 handler:^(id object, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!msg){
            LimitResultModel *model = [LimitResultModel new];
            model = object;
            if ([model.result count] > 0) {
                _isMyCourse = YES;
                _myDataView.hidden = NO;
                _courseArray = [model.result mutableCopy];
                [_courseTableView reloadData];
                
            } else {
                _isMyCourse = NO;
                _myDataView.hidden = YES;
                [self fetchRecommendedCourse];
            }
        }
        
    }];
}
- (void)fetchRecommendedCourse {
    [CourseModel fetchRecommendedCourse:1 handler:^(id object, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!msg) {
            LimitResultModel *model = [LimitResultModel new];
            model = object;
            _courseArray = [model.result mutableCopy];
            [_courseTableView reloadData];
        }
        
    }];
}
- (void)fetchMyData {
    [CourseModel fetchMyData:^(id object, NSString *msg) {
        if (!msg) {
            NSDictionary *dataDictionary = [object copy];
            NSInteger todayTime = [dataDictionary[@"Time"] integerValue];
            NSInteger allTime = [dataDictionary[@"allTime"] integerValue];
            if (allTime % 60 == 0) {
                allTime = allTime / 60;
            } else {
                allTime = allTime / 60 + 1;
            }
            NSDictionary *levelDictionary = dataDictionary[@"level"];
            NSInteger level2Time = [levelDictionary[@"V2"][@"exp"] integerValue] / 60;
            NSInteger level3Time = [levelDictionary[@"V3"][@"exp"] integerValue] / 60;
            NSInteger trainingDays = [dataDictionary[@"trainNum"] integerValue];
            if (trainingDays == 0) {
                _trainingDaysLabel.text = @"今日训练";
            } else {
                _trainingDaysLabel.text = [NSString stringWithFormat:@"今日训练（连续第%ld天）", (long)trainingDays];
            }
            if (todayTime == 0) {
                _todayEnergyLabel.text = @"0";
            } else {
                _todayEnergyLabel.text = [NSString stringWithFormat:@"%ld", (long)todayTime / 60 + 1];
            }
            _rank2Label.text = [NSString stringWithFormat:@"%ld分钟", (long)level2Time];
            _rank3Label.text = [NSString stringWithFormat:@"%ld分钟", (long)level3Time];
            if (allTime < level2Time) {
                _upgradeLabel.text = [NSString stringWithFormat:@"再训练%ld分钟就可以升级了", (long)(level2Time -allTime)];
                _currentEnergyWidthConstraint.constant = (SCREEN_WIDTH - 28) / 2.0 / level2Time * allTime;
                _rank2Image.highlighted = NO;
                _rank2Image.highlighted = NO;
            } else {
                _upgradeLabel.text = [NSString stringWithFormat:@"再训练%ld分钟就可以升级了", (long)(level3Time - allTime)];
                _currentEnergyWidthConstraint.constant = (SCREEN_WIDTH - 28) / 2.0 / (level3Time - level2Time) * (allTime - level2Time) + (SCREEN_WIDTH - 28) / 2.0;
                _rank2Image.highlighted = YES;
                if (allTime >= level3Time) {
                    _rank3Image.highlighted = YES;
                } else {
                    _rank3Image.highlighted = NO;
                }
            }
            
            
        }
    }];
}
- (void)fetchDryList {
    [DrysalteryModel fetchDryListWith:_limit handler:^(id object, NSString *msg) {
        [_drysalteryTableView.header endRefreshing];
        [_drysalteryTableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!msg) {
            LimitResultModel *model = [LimitResultModel new];
            model = object;
            if (_limit == 0) {
                _drysalteryArray = [model.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_drysalteryArray mutableCopy];
                [tempArray addObjectsFromArray:model.result];
                _drysalteryArray = tempArray;
            }
            [_drysalteryTableView reloadData];
            BOOL haveMore = model.haveMore;
            if (haveMore) {
                _limit = model.limit;
                _drysalteryTableView.footer.hidden = NO;
            } else {
                [_drysalteryTableView.footer noticeNoMoreData];
                _drysalteryTableView.footer.hidden = YES;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _drysalteryTableView) {
        return _drysalteryArray.count;
    } else {
        return _courseArray.count;
        //return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _drysalteryTableView) {
        return (SCREEN_WIDTH - 18) / 302 * 179 + 9;
    } else {
        return SCREEN_WIDTH/2 + 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _drysalteryTableView) {
        static NSString *CellIdentifier = @"DryCell";
        DrysalteryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[DrysalteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setupDrysalteryContentWithModel:[_drysalteryArray objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if (_isMyCourse) {
            static NSString *cellIdentifier = @"MyCourseCell";
            MyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setupContent:_courseArray[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            static NSString *cellIdentifier = @"CourseCell";
            CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setupContent:_courseArray[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _drysalteryTableView) {
        DrysalterDetailViewController *drysalterDetailView = [[UIStoryboard storyboardWithName:@"DrysalteryDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"DrysalterDetailView"];
        DrysalteryModel *tempModel = _drysalteryArray[indexPath.row];
        drysalterDetailView.model = tempModel;
        drysalterDetailView.drysalteryId = tempModel.dryId;
        drysalterDetailView.titleStr = tempModel.title;
        [self.navigationController pushViewController:drysalterDetailView animated:YES];
    } else {
        if (_isMyCourse) {
            CourseDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Drysaltery" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailView"];
            detailViewController.courseModel = _courseArray[indexPath.row];
            detailViewController.isJoin = YES;
            [self.navigationController pushViewController:detailViewController animated:YES];
        } else {
            CourseDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Drysaltery" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailView"];
            detailViewController.courseModel = _courseArray[indexPath.row];
            detailViewController.isJoin = NO;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _courseTableView) {
        return 40;
    } else {
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 80, 0, 160, 40)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
    if (_isMyCourse) {
        titleLabel.text = @"我的训练课程";
    } else {
        titleLabel.text = @"为你推荐的课程";
    }
    [headerView addSubview:titleLabel];
    UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 22, 15, 10, 10)];
    moreImage.image = [UIImage imageNamed:@"fitness_button_more"];
    [headerView addSubview:moreImage];
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 76, 40)];
    moreLabel.textAlignment = NSTextAlignmentRight;
    moreLabel.text = @"更多课程";
    moreLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
    moreLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:moreLabel];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(SCREEN_WIDTH - 200, 0, 190, 40);
    [moreButton addTarget:self action:@selector(moreCourseClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:moreButton];
    
    
    return headerView;
}
- (void)moreCourseClick {
    MoreCourseViewController *moreCourseViewController = [[UIStoryboard storyboardWithName:@"Drysaltery" bundle:nil] instantiateViewControllerWithIdentifier:@"MoreCourseView"];
    [self.navigationController pushViewController:moreCourseViewController animated:YES];
}

- (void)controlPressed:(id)sender {
    if (_segment.selectedSegmentIndex == 0) {
        _segmentIndex = 0;
        _viewForTableLeftConstraint.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        _segmentIndex = 1;
        _viewForTableLeftConstraint.constant = -SCREEN_WIDTH;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (UIView *)titleViewForTabbarNav {
    _segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"训练", @"干货", nil]];
    _segment.frame = CGRectMake(0, 0, 120, 30);
    _segment.layer.masksToBounds = YES;
    _segment.layer.cornerRadius = 15.0;
    _segment.layer.borderWidth = 1.0;
    _segment.layer.borderColor = [UIColor whiteColor].CGColor;
    _segment.selectedSegmentIndex = _segmentIndex;
    [_segment addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    return _segment;
    //return nil;
}
- (IBAction)shareDataButtonClick:(id)sender {
}

- (NSString *)titleForTabbarNav {
    return nil;
}

-(NSArray *)leftButtonsForTabbarNav {
    return nil;
}
- (NSArray *)rightButtonsForTabbarNav {
    return nil;
}
- (BOOL)checkIfLogin {
    if (![UserInfo userHaveLogin]) {
        return NO;
    }
    return YES;
}

- (void)showLogin {
    UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:loginVC animated:NO];
}
- (void)showGuide {
    UIViewController *guideVC = [[UIStoryboard storyboardWithName:@"Guide" bundle:nil] instantiateViewControllerWithIdentifier:@"FifthGuideView"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:guideVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tipGuideButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 99) {
        [self showGuide];
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IsNewUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_guideTipView removeFromSuperview];
}
- (IBAction)makePlanButtonClick:(id)sender {
    [self showGuide];
}

@end
