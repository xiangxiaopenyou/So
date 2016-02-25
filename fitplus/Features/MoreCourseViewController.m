//
//  MoreCourseViewController.m
//  fitplus
//
//  Created by xlp on 15/9/24.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "MoreCourseViewController.h"
#import "PopoverView.h"
#import "CommonsDefines.h"
#import "CourseModel.h"
#import "LimitResultModel.h"
#import <MJRefresh.h>
#import "CourseCell.h"
#import "CourseDetailViewController.h"

@interface MoreCourseViewController ()<UITableViewDataSource, UITableViewDelegate>;
@property (weak, nonatomic) IBOutlet UIButton *modelButton;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton;
@property (weak, nonatomic) IBOutlet UIButton *difficultyButton;
@property (weak, nonatomic) IBOutlet UIImageView *modelOpenImage;
@property (weak, nonatomic) IBOutlet UIImageView *bodyOpenImage;
@property (weak, nonatomic) IBOutlet UIImageView *difficultyOpenImage;
@property (nonatomic, strong) PopoverView *modelPopView;
@property (nonatomic, strong) PopoverView *bodyPopView;
@property (nonatomic, strong) PopoverView *difficultyPopView;
@property (strong, nonatomic) NSMutableArray *courseArray;
@property (assign, nonatomic) NSInteger page;
@property (weak, nonatomic) IBOutlet UITableView *courseTableView;
@property (assign, nonatomic) NSInteger modelIndex;
@property (copy, nonatomic) NSString *bodyString;
@property (assign, nonatomic) NSInteger difficultyIndex;
@property (nonatomic, strong) UIButton *backgroundButton;

@end

@implementation MoreCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"更多训练";
    NSArray *modelArray = [NSArray arrayWithObjects:@"不限模式", @"单次", @"周期", nil];
    NSArray *bodyArray = [NSArray arrayWithObjects:@"不限部位", @"全身", @"背部", @"腿部", @"腹部", @"胸部", @"手臂", nil];
    NSArray *difficultyArray = [NSArray arrayWithObjects:@"全部难度", @"初级", @"中级", @"高级", nil];
    
    [self initRefresh];
    _modelIndex = 0;
    _difficultyIndex = 0;
    
    _modelPopView = [[PopoverView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, 0) titles:modelArray];
    [self.view addSubview:_modelPopView];
    [_modelPopView clickTableViewRow:^(NSInteger index) {
        _modelIndex = index;
        [_modelButton setTitle:modelArray[index] forState:UIControlStateNormal];
        [_modelButton setTitle:modelArray[index] forState:UIControlStateSelected];
        [self closeModelPopView];
        _page = 1;
        [self fetchCourseList];
    }];
    
    _bodyPopView = [[PopoverView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, 0) titles:bodyArray];
    [self.view addSubview:_bodyPopView];
    [_bodyPopView clickTableViewRow:^(NSInteger index) {
        if (index == 0) {
            _bodyString = nil;
        } else {
            _bodyString = bodyArray[index];
        }
        [_bodyButton setTitle:bodyArray[index] forState:UIControlStateNormal];
        [_bodyButton setTitle:bodyArray[index] forState:UIControlStateSelected];
        [self closeBodyPopView];
        _page = 1;
        [self fetchCourseList];
    }];
    
    _difficultyPopView = [[PopoverView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, 0) titles:difficultyArray];
    [self.view addSubview:_difficultyPopView];
    [_difficultyPopView clickTableViewRow:^(NSInteger index) {
        _difficultyIndex = index;
        [_difficultyButton setTitle:difficultyArray[index] forState:UIControlStateNormal];
        [_difficultyButton setTitle:difficultyArray[index] forState:UIControlStateSelected];
        [self closeDifficultyPopView];
        _page = 1;
        [self fetchCourseList];
    }];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     _page = 1;
    [self fetchCourseList];
}
- (void)initRefresh {
    [_courseTableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self fetchCourseList];
    }]];
    [_courseTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchCourseList];
    }]];
}
- (void)fetchCourseList {
    [CourseModel fetchMoreCourse:_page difficulty:_difficultyIndex model:_modelIndex site:_bodyString handler:^(id object, NSString *msg) {
        [_courseTableView.header endRefreshing];
        [_courseTableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *tempModel = [LimitResultModel new];
            tempModel = object;
            if (_page == 1) {
                _courseArray = [tempModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_courseArray mutableCopy];
                [tempArray addObjectsFromArray:tempModel.result];
                _courseArray = tempArray;
            }
            [_courseTableView reloadData];
            BOOL haveMore = tempModel.haveMore;
            if (haveMore) {
                _page = tempModel.page;
                _courseTableView.footer.hidden = NO;
            } else {
                [_courseTableView.footer noticeNoMoreData];
                _courseTableView.footer.hidden = YES;
            }
        } else {
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseModelClick:(id)sender {
    if (_modelButton.selected) {
        [self closeModelPopView];
    }
    else {
        [_modelPopView show];
        [self openImageChange:1];
        _modelButton.selected = YES;
        [self closeBodyPopView];
        [self closeDifficultyPopView];
        [self addbackButton];
    }
}
- (IBAction)chooseBodyClick:(id)sender {
    if (_bodyButton.selected) {
        [self closeBodyPopView];
    }
    else {
        [_bodyPopView show];
        [self openImageChange:2];
        _bodyButton.selected = YES;
        [self closeModelPopView];
        [self closeDifficultyPopView];
        [self addbackButton];
    }
}
- (IBAction)chooseDifficultyClick:(id)sender {
    if (_difficultyButton.selected) {
        [self closeDifficultyPopView];
    }
    else {
        
        [_difficultyPopView show];
        [self openImageChange:3];
        _difficultyButton.selected = YES;
        [self closeModelPopView];
        [self closeBodyPopView];
        [self addbackButton];
    }
    
}
- (void)addbackButton {
    _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundButton.frame = CGRectMake(0, 317, SCREEN_WIDTH, SCREEN_HEIGHT - 317);
    [_backgroundButton addTarget:self action:@selector(backgroundClick) forControlEvents:UIControlEventTouchUpInside];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_backgroundButton];
}
- (void)backgroundClick {
    [self closeModelPopView];
    [self closeBodyPopView];
    [self closeDifficultyPopView];
}
- (void)closeModelPopView {
    [_backgroundButton removeFromSuperview];
    [_modelPopView dismiss];
    [self closeImage:1];
    _modelButton.selected = NO;
}
- (void)closeBodyPopView {
    [_backgroundButton removeFromSuperview];
    [_bodyPopView dismiss];
    [self closeImage:2];
    _bodyButton.selected = NO;
}
- (void)closeDifficultyPopView {
    [_backgroundButton removeFromSuperview];
    [_difficultyPopView dismiss];
    [self closeImage:3];
    _difficultyButton.selected = NO;
}

- (void)openImageChange:(NSInteger)index {
    CGFloat rotation = M_PI;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
        if (index == 1) {
            _modelOpenImage.transform = transform;
        } else if (index == 2) {
            _bodyOpenImage.transform = transform;
        } else {
            _difficultyOpenImage.transform = transform;
        }
    } completion:nil];
}
- (void)closeImage:(NSInteger)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        if (index == 1) {
            _modelOpenImage.transform = transform;
        } else if (index == 2) {
            _bodyOpenImage.transform = transform;
        } else {
            _difficultyOpenImage.transform = transform;
        }
    } completion:nil];
}

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _courseArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / 2 + 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CourseCell";
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupContent:_courseArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Drysaltery" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailView"];
    CourseModel *tempModel = _courseArray[indexPath.row];
    detailViewController.courseModel = tempModel;
    if ([tempModel.isJoin integerValue] == 0) {
        detailViewController.isJoin = NO;
    } else {
        detailViewController.isJoin = YES;
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
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
