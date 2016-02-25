//
//  CourseDetailViewController.m
//  fitplus
//
//  Created by xlp on 15/9/28.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CommonsDefines.h"
#import "RBColorTool.h"
#import "CourseDetailModel.h"
#import "CourseDayCell.h"
#import "CourseActionCell.h"
#import "CourseTrendModel.h"
#import <MJRefresh.h>
#import "LimitResultModel.h"
#import "CourseMemberCell.h"
#import "FriendsTrendCell.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"
#import "VideoPreviewViewController.h"
#import "CourseTrainingViewController.h"
#import "RBBlockAlertView.h"
#import "RBNoticeHelper.h"
#import "RBBlockActionSheet.h"
#import "VideoModel.h"
#import "DownloadVideo.h"
#import <MBProgressHUD.h>

#define HeaderButtonCommonColor [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0]
#define HeaderButtonSelectedColor [UIColor colorWithRed:104/255.0 green:64/255.0 blue:148/255.0 alpha:1.0]


@interface CourseDetailViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *detailTableView;

@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UIImage *shadowImage;

@property (strong, nonatomic) UILabel *courseNameLabel;
@property (strong, nonatomic) UILabel *courseIntroductionLabel;
@property (strong, nonatomic) UILabel *levelLabel;
@property (strong, nonatomic) UILabel *daysLabel;
@property (strong, nonatomic) UILabel *bodyLabel;
@property (strong, nonatomic) UILabel *targetDayLabel;
@property (strong, nonatomic) UILabel *courseTimeLabel;
@property (strong, nonatomic) UILabel *courseActionLabel;
@property (strong, nonatomic) UILabel *energyLabel;
@property (strong, nonatomic) UILabel *labelTime;
@property (strong, nonatomic) UILabel *labelAction;
@property (strong, nonatomic) UILabel *labelEnergy;
@property (strong, nonatomic) UIButton *trendsButton;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) UIImageView *trendsImage;
@property (strong, nonatomic) UIImageView *actionImage;
@property (strong, nonatomic) UIButton *bottomButton;
@property (strong, nonatomic) CourseDetailModel *detailModel;
@property (strong, nonatomic) NSMutableArray *actionArray;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSIndexPath *nextSeletedIndexPath;
@property (assign, nonatomic) BOOL isOpen;
@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) NSMutableArray *memberArray;
@property (strong, nonatomic) NSMutableArray *trendArray;
@property (strong, nonatomic) NSMutableArray *videoArray;
@property (assign, nonatomic) NSInteger nowCourseDay;
@property (assign, nonatomic) NSInteger nowDay;
@property (nonatomic, copy) NSString *cachePath;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishViewClose) name:@"FinishShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadVideoSuccess:) name:@"DownloadSuccess" object:nil];
    _shadowImage = self.navigationController.navigationBar.shadowImage;
    _cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private/Documents/Cache"];
    _fileManager = [NSFileManager defaultManager];

    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 269)];
    [_topImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:_courseModel.coursePicture]] placeholderImage:[UIImage imageNamed:@"default_image"]];
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.clipsToBounds = YES;
    [self.view addSubview:_topImageView];
    
    _isOpen = NO;
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.backgroundColor = [UIColor clearColor];
    _detailTableView.tableFooterView = [UIView new];
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_detailTableView];
    
    if (_isJoin) {
        _selectedType = 1;
    } else {
        _selectedType = 2;
    }
    
    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45);
    if (_isJoin) {
        [_bottomButton setTitle:[NSString stringWithFormat:@"开始第%ld天训练", (long)[_courseModel.couserDayEnNum integerValue] + 1] forState:UIControlStateNormal];
    } else {
        [_bottomButton setTitle:@"添加训练" forState:UIControlStateNormal];
    }
    _bottomButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _bottomButton.backgroundColor = [UIColor colorWithRed:77/255.0 green:62/355.0 blue:93/255.0 alpha:1.0];
    [_bottomButton addTarget:self action:@selector(bottomButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomButton];
    _bottomButton.hidden = YES;
    
    [self addTableHeaderView];
    
    [_detailTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_selectedType == 1) {
            [self fetchCourseTrends];
        }
    }]];
    
    _limit = 0;
    [self fetchCourseMember];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"drysaltery_detail_header"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[RBColorTool imageWithColor:[UIColor colorWithRed:0.234 green:0.180 blue:0.292 alpha:1.000]]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = _shadowImage;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchCourseDetail];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FinishShare" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DownloadSuccess" object:nil];
}
- (void)addTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 309)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 269)];
    //contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [headerView addSubview:contentView];
    
    _courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 80, SCREEN_WIDTH - 28, 20)];
    _courseNameLabel.text = _courseModel.courseName;
    _courseNameLabel.textColor = [UIColor whiteColor];
    _courseNameLabel.font = [UIFont boldSystemFontOfSize:20];
    _courseNameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [contentView addSubview:_courseNameLabel];
    
    _courseIntroductionLabel = [[UILabel alloc] init];
    _courseIntroductionLabel.numberOfLines = 0;
    _courseIntroductionLabel.textColor = [UIColor whiteColor];
    _courseIntroductionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _courseIntroductionLabel.font = [UIFont systemFontOfSize:12];
    //_courseIntroductionLabel.text = _courseModel
    [contentView addSubview:_courseIntroductionLabel];
    
    _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 110, 30, 15)];
    _levelLabel.font = [UIFont systemFontOfSize:12];
    _levelLabel.textColor = [UIColor whiteColor];
    switch (_courseModel.courseModel) {
        case 1:{
            _levelLabel.text = @"初级";
        }
            break;
        case 2:{
            _levelLabel.text = @"中级";
        }
            break;
        case 3:{
            _levelLabel.text = @"高级";
        }
            break;
            
        default:
            break;
    }
    _levelLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [contentView addSubview:_levelLabel];
    
    _daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 110, 30, 15)];
    _daysLabel.font = [UIFont systemFontOfSize:12];
    _daysLabel.textColor = [UIColor whiteColor];
    _daysLabel.text = [NSString stringWithFormat:@"%ld天", (long)_courseModel.courseDays];
    [contentView addSubview:_daysLabel];
    
    _bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 110, 50, 15)];
    _bodyLabel.font = [UIFont systemFontOfSize:12];
    _bodyLabel.textColor = [UIColor whiteColor];
    _bodyLabel.text = [NSString stringWithFormat:@"%@", _courseModel.courseBody];
    [contentView addSubview:_bodyLabel];
    
    _targetDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 175, SCREEN_WIDTH - 28, 20)];
    _targetDayLabel.textColor = [UIColor whiteColor];
    _targetDayLabel.font = [UIFont systemFontOfSize:12];
    if ([_courseModel.couserDayEnNum integerValue] == _courseModel.courseDays) {
        _targetDayLabel.text = @"训练已全部完成";
    } else {
        NSString *day = [NSString stringWithFormat:@"%ld", (long)[_courseModel.couserDayEnNum integerValue] + 1];
        NSString *targetDayString = [NSString stringWithFormat:@"今日目标%ld/%ld天", (long)[_courseModel.couserDayEnNum integerValue] + 1, (long)_courseModel.courseDays];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:targetDayString];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(4, [day length])];
        _targetDayLabel.attributedText = attributedString;
        
    }
    _targetDayLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [contentView addSubview:_targetDayLabel];
    
    _courseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 210, 80, 20)];
    _courseTimeLabel.font = [UIFont systemFontOfSize:12];
    _courseTimeLabel.textColor = [UIColor whiteColor];
    _courseTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:_courseTimeLabel];
    
    _courseActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 210, 100, 20)];
    _courseActionLabel.font = [UIFont systemFontOfSize:12];
    _courseActionLabel.textColor = [UIColor whiteColor];
    _courseActionLabel.textAlignment = NSTextAlignmentCenter;
    _courseActionLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:_courseActionLabel];
    
    _energyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 112, 210, 80, 20)];
    _energyLabel.font = [UIFont systemFontOfSize:12];
    _energyLabel.textColor = [UIColor whiteColor];
    _energyLabel.textAlignment = NSTextAlignmentRight;
    _energyLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:_energyLabel];
    
    _labelTime = [[UILabel alloc] initWithFrame:CGRectMake(31, 235, 80, 20)];
    _labelTime.font = [UIFont systemFontOfSize:12];
    _labelTime.textColor = [UIColor whiteColor];
    _labelTime.text = @"时长";
    _labelTime.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:_labelTime];
    
    _labelAction = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 232, 100, 20)];
    _labelAction.font = [UIFont systemFontOfSize:12];
    _labelAction.textColor = [UIColor whiteColor];
    _labelAction.text = @"动作";
    _labelAction.textAlignment = NSTextAlignmentCenter;
    _labelAction.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:_labelAction];
    
    _labelEnergy = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 112, 232, 80, 20)];
    _labelEnergy.font = [UIFont systemFontOfSize:12];
    _labelEnergy.textColor = [UIColor whiteColor];
    _labelEnergy.text = @"燃烧热量";
    _labelEnergy.textAlignment = NSTextAlignmentRight;
    _labelEnergy.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:_labelEnergy];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 269, SCREEN_WIDTH, 40)];
    //buttonView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:buttonView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    [buttonView addSubview:lineLabel];
    
    _trendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _trendsButton.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, 39);
    [_trendsButton setTitle:@"好友动态" forState:UIControlStateNormal];
    [_trendsButton addTarget:self action:@selector(trendsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_trendsButton];
    
    _trendsImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4 - 6, 34, 12, 6)];
    _trendsImage.image = [UIImage imageNamed:@"fit_rect"];
    [buttonView addSubview:_trendsImage];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 39);
    [_actionButton setTitle:@"分解动作" forState:UIControlStateNormal];
    [_actionButton addTarget:self action:@selector(actionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_actionButton];
    
    _actionImage = [[UIImageView alloc] initWithFrame:CGRectMake(3 * SCREEN_WIDTH / 4 - 6, 34, 12, 6)];
    _actionImage.image = [UIImage imageNamed:@"fit_rect"];
    [buttonView addSubview:_actionImage];
    
    [self setupHeaderView];
    
    //_detailTableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    _detailTableView.tableHeaderView = headerView;
}
- (void)setupHeaderView {
    [_detailTableView reloadData];
    if (_selectedType == 1) {
        [_trendsButton setTitleColor:HeaderButtonSelectedColor forState:UIControlStateNormal];
        [_actionButton setTitleColor:HeaderButtonCommonColor forState:UIControlStateNormal];
        _trendsImage.hidden = NO;
        _actionImage.hidden = YES;
        
    } else {
        [_trendsButton setTitleColor:HeaderButtonCommonColor forState:UIControlStateNormal];
        [_actionButton setTitleColor:HeaderButtonSelectedColor forState:UIControlStateNormal];
        _trendsImage.hidden = YES;
        _actionImage.hidden = NO;
        _detailTableView.footer.hidden = YES;
    }
}
- (void)fetchCourseDetail {
    [CourseDetailModel fetchCourseDetailWith:_courseModel.courseId handler:^(id object, NSString *msg) {
        if (!msg) {
            _bottomButton.hidden = NO;
            _detailModel = [CourseDetailModel new];
            _detailModel = object;
            _nowCourseDay = [_detailModel.day_data[@"day_name"] integerValue];
            _nowDay = _nowCourseDay;
            [self setupData:_detailModel];
            _actionArray = [_detailModel.day_list mutableCopy];
            [_detailTableView reloadData];
            if (_isJoin) {
                [self fetchVideoList];
            }
        }
    }];
}
- (void)fetchCourseMember {
    [CourseTrendModel fetchCourseMember:_courseModel.courseId limit:0 handler:^(id object, NSString *msg) {
        if (!msg) {
            _memberArray = [object[@"userList"] mutableCopy];
        }
         [self fetchCourseTrends];
    }];
}
- (void)fetchCourseTrends {
    [CourseTrendModel fetchCourseTrends:_courseModel.courseId limit:_limit handler:^(id object, NSString *msg) {
        if (!msg) {
             LimitResultModel *tempModel = [LimitResultModel new];
            tempModel = object;
            if (_limit == 0) {
                _trendArray = [tempModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_trendArray mutableCopy];
                [tempArray addObjectsFromArray:tempModel.result];
                _trendArray = tempArray;
            }
            [_detailTableView reloadData];
            BOOL haveMore = tempModel.haveMore;
            if (haveMore) {
                _limit = tempModel.limit;
                _detailTableView.footer.hidden = NO;
            } else {
                [_detailTableView.footer noticeNoMoreData];
                _detailTableView.footer.hidden = YES;
            }
        }
       
    }];
}
- (void)joinCourse {
    NSString *dayIdString = @"";
    for (NSDictionary *tempDictionary in _actionArray) {
        dayIdString = [dayIdString stringByAppendingString:tempDictionary[@"day_id"]];
        dayIdString = [dayIdString stringByAppendingString:@","];
    }
    dayIdString = [dayIdString substringWithRange:NSMakeRange(0, [dayIdString length] - 1)];
    [CourseDetailModel joinCourseWith:_courseModel.courseId dayId:dayIdString handler:^(id object, NSString *msg) {
        if (!msg) {
            _isJoin = YES;
            [self fetchCourseDetail];
        }
    }];
}
- (void)setupData:(CourseDetailModel *)model {
    if (_nowCourseDay == 0) {
        _targetDayLabel.text = @"训练已经全部完成";
    } else {
        NSString *day = [NSString stringWithFormat:@"%ld", (long)_nowCourseDay];
        NSString *targetDayString = [NSString stringWithFormat:@"今日目标%@/%ld天", day, (long)_courseModel.courseDays];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:targetDayString];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(4, [day length])];
        _targetDayLabel.attributedText = attributedString;
    }
    if (!_isJoin) {
        self.navigationItem.rightBarButtonItem = nil;
        NSString *introString = model.desc;
        CGSize size = [introString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 28, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, nil] context:nil].size;
        _courseIntroductionLabel.frame = CGRectMake(14, 110, SCREEN_WIDTH - 28, size.height);
        _courseIntroductionLabel.text = introString;
        _courseIntroductionLabel.hidden = NO;
        
        _labelTime.text = @"挑战周期";
        _courseTimeLabel.text = [NSString stringWithFormat:@"%ld天", (long)_courseModel.courseDays];
        NSString *day = [NSString stringWithFormat:@"%ld", (long)_courseModel.courseDays];
        NSString *targetDayString = [NSString stringWithFormat:@"%ld天", (long)_courseModel.courseDays];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:targetDayString];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, [day length])];
        _courseTimeLabel.attributedText = attributedString;
        
        _labelAction.hidden = YES;
        _courseActionLabel.hidden = YES;
        
        _labelEnergy.frame = CGRectMake(SCREEN_WIDTH / 2 - 50, 232, 100, 20);
        _energyLabel.frame = CGRectMake(SCREEN_WIDTH / 2 - 50, 210, 100, 20);
        NSString *energyString = [NSString stringWithFormat:@"%ld", (long)_courseModel.total_calories];
        NSString *energyForString = [NSString stringWithFormat:@"%@千卡", energyString];
        NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:energyForString];
        [attString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, [energyString length])];
        _energyLabel.attributedText = attString3;
        
        _levelLabel.frame = CGRectMake(14, 180, 30, 15);
        _daysLabel.hidden = YES;
        _bodyLabel.frame = CGRectMake(52, 180, 50, 15);
        _targetDayLabel.hidden = YES;
        
        [_bottomButton setTitle:@"添加训练" forState:UIControlStateNormal];

    } else {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clockin_detail_options"] style:UIBarButtonItemStyleBordered target:self action:@selector(exitButtonClick)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        _courseIntroductionLabel.hidden = YES;
        _labelTime.text = @"时长";
        NSDictionary *tempDictionary = model.day_data;
        NSArray *actionArray = [tempDictionary[@"resolve_list"] mutableCopy];
        NSInteger time = [tempDictionary[@"total_time"] integerValue] / 60 + 1;
        NSString *timeString = [NSString stringWithFormat:@"%ld", (long)time];
        NSString *timeForString = [NSString stringWithFormat:@"%@分钟", timeString];
        NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:timeForString];
        [attString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, [timeString length])];
        _courseTimeLabel.attributedText = attString1;
        
        _labelAction.hidden = NO;
        _courseActionLabel.hidden = NO;
        NSString *actionString = [NSString stringWithFormat:@"%ld", actionArray.count];
        NSString *actionForString = [NSString stringWithFormat:@"%@个", actionString];
        NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:actionForString];
        [attString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, [actionString length])];
        _courseActionLabel.attributedText = attString2;
        
        _labelEnergy.frame = CGRectMake(SCREEN_WIDTH - 112, 232, 80, 20);
        _energyLabel.frame = CGRectMake(SCREEN_WIDTH - 112, 210, 80, 20);
        
        NSString *energyString = nil;
        if ([tempDictionary[@"calories"] integerValue] > 0) {
            energyString = [NSString stringWithFormat:@"%@", tempDictionary[@"calories"]];
        } else {
            energyString = @"0";
        }
        NSString *energyForString = [NSString stringWithFormat:@"%@千卡", energyString];
        NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:energyForString];
        [attString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, [energyString length])];
        _energyLabel.attributedText = attString3;
        
        _levelLabel.frame = CGRectMake(14, 110, 30, 15);
        _daysLabel.hidden = NO;
        _bodyLabel.frame = CGRectMake(90, 110, 50, 15);
        _targetDayLabel.hidden = NO;
        if (_nowCourseDay == 0) {
            [_bottomButton setTitle:@"训练已经全部完成" forState:UIControlStateNormal];
            _nowCourseDay = 1;
        } else {
            [_bottomButton setTitle:[NSString stringWithFormat:@"开始第%ld天训练", _nowCourseDay] forState:UIControlStateNormal];
        }
    }
    [self setupHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Delegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_selectedType == 1) {
        return 1;
    } else {
        return _actionArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectedType == 1) {
        return _trendArray.count + 1;
    } else {
        if (_isOpen) {
            if (_selectedIndexPath.section == section) {
                NSDictionary *tempDictionary =  _actionArray[section];
                NSArray *tempArray = tempDictionary[@"resolve_list"];
                return [tempArray count] + 1;
            }
        }
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedType ==1) {
        if (indexPath.row == 0) {
            return 50;
        } else {
            return 60;
        }
    } else {
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedType == 1) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"CourseMemberCell";
            CourseMemberCell *cell = (CourseMemberCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            cell.courseMemberLabel.text = [NSString stringWithFormat:@"%ld人", _courseModel.courseMember];
            if (_memberArray.count > 7) {
                for (NSInteger i = 0; i < 7; i ++) {
                    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80 + i * 31.5, 10, 30, 30)];
                    headImageView.layer.masksToBounds = YES;
                    headImageView.layer.cornerRadius = 15.0;
                    [headImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:_memberArray[i][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
                    [cell.contentView addSubview:headImageView];
                }
                UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(305, 0, 30, 50)];
                moreLabel.font = [UIFont systemFontOfSize:18];
                moreLabel.text = @"···";
                moreLabel.textColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0];
                [cell.contentView addSubview:moreLabel];
                
            } else {
                for (NSInteger i = 0; i < _memberArray.count; i ++) {
                    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80 + i * 31.5, 10, 30, 30)];
                    headImageView.layer.masksToBounds = YES;
                    headImageView.layer.cornerRadius = 15.0;
                    [headImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:_memberArray[i][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
                    [cell.contentView addSubview:headImageView];
                }
            }
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"FriendsTrendCell";
            FriendsTrendCell *cell = (FriendsTrendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            cell.headImage.layer.masksToBounds = YES;
            cell.headImage.layer.cornerRadius = 20.0;
            CourseTrendModel *tempModel = [CourseTrendModel new];
            tempModel = _trendArray[indexPath.row - 1];
            [cell.headImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:tempModel.portrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
            cell.nicknameLabel.text = tempModel.nickname;
            cell.courseDayLabel.text = [NSString stringWithFormat:@"第%ld天", tempModel.courseday];
            cell.energyLabel.text = [NSString stringWithFormat:@"%ld千卡", tempModel.calorie];
            return cell;
        }
    }
    else {
        if (_isOpen && _selectedIndexPath.section == indexPath.section && indexPath.row != 0) {
            static NSString *CellIdentifier = @"CourseActionCell";
            CourseActionCell *cell = (CourseActionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            NSDictionary *tempDictionary = _actionArray[indexPath.section];
            NSArray *tempArray = tempDictionary[@"resolve_list"];
            NSDictionary *tempActionDictionary = tempArray[indexPath.row - 1];
            cell.actionNameLabel.text = tempActionDictionary[@"name"];
            cell.groupNumberLabel.text = [NSString stringWithFormat:@"%@*%@", tempActionDictionary[@"num"], tempActionDictionary[@"group_num"]];
            NSInteger timeInt = [tempActionDictionary[@"sum_times"] integerValue];
            if (timeInt / 60 > 0) {
                cell.actionTimeLabel.text = [NSString stringWithFormat:@"%ld分%ld秒", (long)timeInt / 60, (long)timeInt % 60];
            } else {
                cell.actionTimeLabel.text = [NSString stringWithFormat:@"%ld秒", (long)timeInt % 60];
            }
            return cell;
        } else {
            static NSString *CellIdentifier = @"CourseDayCell";
            CourseDayCell *cell = (CourseDayCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            cell.rowIndex = indexPath.section;
            NSDictionary *tempDictionary = _actionArray[indexPath.section];
//            if (_nowDay == 0) {
//                cell.stateImage.image = [UIImage imageNamed:@"training_details_unselected"];
//                cell.canClick = YES;
//            } else {
            if (!_isJoin) {
                cell.stateImage.image = [UIImage imageNamed:@"training_details_locked"];
                cell.canClick = NO;
            } else {
                if (_nowDay == 0) {
                    if (indexPath.section == _nowCourseDay - 1) {
                        cell.stateImage.image = [UIImage imageNamed:@"training_type_selected"];
                        cell.canClick = NO;
                    } else {
                        cell.stateImage.image = [UIImage imageNamed:@"training_details_unselected"];
                        cell.canClick = YES;
                    }
                } else {
                    if (indexPath.section >= _nowDay) {
                        cell.stateImage.image = [UIImage imageNamed:@"training_details_locked"];
                        cell.canClick = NO;
                    } else {
                        if (indexPath.section == _nowCourseDay - 1) {
                            cell.stateImage.image = [UIImage imageNamed:@"training_type_selected"];
                            cell.canClick = NO;
                        } else {
                            cell.stateImage.image = [UIImage imageNamed:@"training_details_unselected"];
                            cell.canClick = YES;
                        }
                    }
                }
            }
            
           // }
            cell.courseDayNameLabel.text = [NSString stringWithFormat:@"第%ld天：%@", (long)indexPath.section + 1, tempDictionary[@"resolve_name"]];
            NSInteger timeInt = [tempDictionary[@"total_time"] integerValue];
            if (timeInt / 60 > 0) {
                cell.courseDaysTime.text = [NSString stringWithFormat:@"%ld分%ld秒", (long)timeInt / 60, (long)timeInt % 60];
            } else {
                cell.courseDaysTime.text = [NSString stringWithFormat:@"%ld秒", (long)timeInt % 60];
            }
            if (indexPath.section == _actionArray.count - 1 && _isOpen) {
                UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                line1.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
                [cell.contentView addSubview:line1];
            }
            [cell selected:^(NSInteger index) {
                _nowCourseDay = index + 1;
                [_detailTableView reloadData];
                [_bottomButton setTitle:[NSString stringWithFormat:@"开始第%ld天训练", (long)_nowCourseDay] forState:UIControlStateNormal];
                [self fetchVideoList];
            }];
            
            return cell;
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedType == 1) {
        
    } else {
        if (indexPath.row == 0) {
            if ([indexPath isEqual:_selectedIndexPath]) {
                _isOpen = NO;
                [self didSelectCellRow:NO next:NO];
                _selectedIndexPath = nil;
            } else {
                if (!_selectedIndexPath) {
                    _selectedIndexPath = indexPath;
                    [self didSelectCellRow:YES next:NO];
                } else {
                    _nextSeletedIndexPath = indexPath;
                    [self didSelectCellRow:NO next:YES];
                }
            }
            
        } else {
            VideoPreviewViewController *previewViewController = [[UIStoryboard storyboardWithName:@"Drysaltery" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoPreviewView"];
            previewViewController.previewIndex = indexPath.row;
            NSDictionary *tempDictionary = _actionArray[indexPath.section];
            previewViewController.actionArray = tempDictionary[@"resolve_list"];
            previewViewController.dayId = tempDictionary[@"day_id"];
            previewViewController.model = _courseModel;
            [self presentViewController:previewViewController animated:YES completion:nil];
        }
    }
    
}
- (void)didSelectCellRow:(BOOL)isInsert next:(BOOL)nextInsert {
    _isOpen = isInsert;
   // CourseDayCell *cell = (CourseDayCell *)[_detailTableView cellForRowAtIndexPath:_selectedIndexPath];
    [_detailTableView beginUpdates];
    NSInteger section = _selectedIndexPath.section;
    NSInteger selectedRowCount = [_actionArray[section][@"resolve_list"] count];
    NSMutableArray *insertRowArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < selectedRowCount + 1; i ++) {
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [insertRowArray addObject:insertIndexPath];
    }
    if (isInsert) {
        [_detailTableView insertRowsAtIndexPaths:insertRowArray withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [_detailTableView deleteRowsAtIndexPaths:insertRowArray withRowAnimation:UITableViewRowAnimationTop];
        [_detailTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
        _topImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 269);
        
    }
    [_detailTableView endUpdates];
    if (nextInsert) {
        _isOpen = YES;
        _selectedIndexPath = _nextSeletedIndexPath;
        [self didSelectCellRow:YES next:NO];
    }
    if (_isOpen) {
        [_detailTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma Mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    CGRect frame = _topImageView.frame;
    if (y < 0) {
        frame.origin.y = 0;
        frame.size.height = 269 - y;
        _topImageView.frame = frame;
    } else {
        frame.origin.y = - y;
        frame.size.height = 269;
        _topImageView.frame = frame;
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
- (void)exitButtonClick {
    if (_isJoin) {
        [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[[RBBlockAlertView alloc] initWithTitle:@"提示" message:@"确定要退出训练吗？" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [CourseModel exitCourse:_courseModel.courseId handler:^(id object, NSString *msg) {
                            if (!msg) {
                                [RBNoticeHelper showNoticeAtViewController:self msg:@"退出训练成功"];
                                _isJoin = NO;
                                [self fetchCourseDetail];
                            } else {
                                [RBNoticeHelper showNoticeAtViewController:self msg:@"退出训练失败"];
                            }
                        }];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出训练" otherButtonTitles:nil, nil] showInView:self.view];
        
    }
    
}
- (void)bottomButtonClick {
    if (_isJoin) {
        VideoModel *tempModel = _videoArray[0];
        if ([_fileManager fileExistsAtPath:[_cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", tempModel.id]]]) {
            [self turnToTrainingView];
        } else {
            [self downloadVideo];
        }

        
    } else {
        [self joinCourse];
    }
    
}
//获取视频
- (void)fetchVideoList {
    [VideoModel fetchVideoListOfDay:_actionArray[_nowCourseDay - 1][@"day_id"] handler:^(id object, NSString *msg) {
        if (!msg) {
            _videoArray = [object mutableCopy];
        }
        
    }];
}
- (void)downloadVideo {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud setLabelText:@"正在下载视频..."];
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.dimBackground = YES;
    [hud show:YES];
    if (![_fileManager fileExistsAtPath:_cachePath]) {
        [_fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (NSInteger i = 0; i < _videoArray.count; i ++) {
        VideoModel *tempModel = _videoArray[i];
        if (![_fileManager fileExistsAtPath:[_cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", tempModel.id]]]) {
            [[DownloadVideo new] downloadFileURL:tempModel.path fileName:[NSString stringWithFormat:@"%@.mp4", tempModel.id] tag:i];
        } else {
            if (i == _videoArray.count - 1) {
                [self turnToTrainingView];
            }
        }
    }
}
- (void)turnToTrainingView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    CourseTrainingViewController *trainingViewController = [[UIStoryboard storyboardWithName:@"Drysaltery" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseTrainingView"];
    trainingViewController.actionDictionary = _actionArray[_nowCourseDay - 1];
    trainingViewController.courseModel = _courseModel;
    trainingViewController.videoArray = _videoArray;
    [self presentViewController:trainingViewController animated:YES completion:nil];
}
- (void)downloadVideoSuccess:(NSNotification *)notification {
    NSInteger receiveTag = [notification.object integerValue];
    if (receiveTag == _videoArray.count - 1) {
        [self turnToTrainingView];
    }
}

- (void)trendsButtonClick {
    _selectedType = 1;
    [self setupHeaderView];
}
- (void)actionButtonClick {
    _selectedType = 2;
    [self setupHeaderView];
}
- (void)finishViewClose {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
