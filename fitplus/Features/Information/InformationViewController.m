//
//  BackHomeViewController.m
//  fitplus
//
//  Created by 陈 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "InformationViewController.h"
#import "KDMainViewController.h"
#import "InformationModel.h"
#import "informationImageModel.h"
#import "InformationTableViewCell.h"
#import "ClockInDetailViewController.h"
#import "AttentionViewController.h"
#import "AddAttentionModel.h"
#import <MJRefresh.h>
#import "RBNoticeHelper.h"
#import "CommonsDefines.h"
#import "ClockInInforModel.h"
#import "FansViewController.h"
#import <MBProgressHUD.h>
#import "AddAttentionModel.h"
#import "LimitResultModel.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>
#import "DrysalteryCell.h"
#import "DrysalteryModel.h"
#import "LimitResultModel.h"
#import "RBColorTool.h"
#import "PersonalViewController.h"
#import "RecordCell.h"
#import "DrysalterDetailViewController.h"
#import "UIImage+ImageEffects.h"
#import "UserCourseTrendModel.h"
//#import "FriendsTrendCell.h"
#import "MyCourseTrendCell.h"

#define VIEW_SIZE_WIDTH  [UIScreen mainScreen].bounds.size.width
#define imageUrlStr @"http://7u2h8u.com1.z0.glb.clouddn.com/"

@interface InformationViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *recordImage;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;
@property (weak, nonatomic) IBOutlet UIImageView *courseTrendsImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraints;
@property (weak, nonatomic) IBOutlet UIImageView *headBackgroundImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConsttaint;
@property (strong, nonatomic) InformationModel *information;
@property (copy, nonatomic) NSMutableArray *dataMutableArray;
@property (copy, nonatomic) NSMutableArray *members;
@property (copy, nonatomic) NSMutableArray *memberArray;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) CGPoint lastPoint;
@property (assign, nonatomic) NSInteger collectionLimit;
@property (strong, nonatomic) NSMutableArray *collectionArray;
@property (strong, nonatomic) NSMutableArray *courseTrendsArray;
@property (assign, nonatomic) NSInteger courseTrendsPage;
@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageSuccess) name:ClockInOverNotificationKey object:nil];
    _currentIndex = 3;
    [_headImage.layer setCornerRadius:27.5];
    [_headImage setClipsToBounds:YES];
    [_headView.layer setCornerRadius:28.5];
    [_headView setClipsToBounds:YES];
    _tableView.tableFooterView = [UIView new];
    _collectionImage.image = [UIImage imageNamed:@"mine_collection"];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self initRefresh];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _collectionLimit = 0;
    _courseTrendsPage = 1;
    
    
}
- (void)sendMessageSuccess {
    if (_currentIndex == 1) {
        [_tableView.header beginRefreshing];
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getInformationDate];
    _tableViewTopConsttaint.constant = 0;
    if (_currentIndex == 1) {
        [self fetchRecord];
    } else if (_currentIndex == 2){
        [self fetchCollectionList];
    } else {
        if (_friendid) {
            [self fetchUserCourseTrends];
        } else {
            [self fetchMyCourseTrends];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark information
- (void)getInformationDate{
    if (!_friendid) {
        [_VariableButton setBackgroundImage:[UIImage imageNamed:@"edit_info_data"] forState:UIControlStateNormal];
        _buttonHeightConstraints.constant = 26;
        _buttonWidthConstraints.constant = 166;
    }else {
        _buttonHeightConstraints.constant = 30;
        _buttonWidthConstraints.constant = 164;
    }
    [InformationModel getInfoMassggeWithFrendid:_friendid handler:^(InformationModel *object, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:msg];
        }else{
            _information = object;
            _addressLabel.text = object.area;
            _signatureLabel.text = object.introduce;
            _nameLabel.text = object.nickname;
            [_Attention setTitle:object.attention_num forState:UIControlStateNormal];
            [_fansButton setTitle:object.fans_num forState:UIControlStateNormal];
            _imagePageLabel.text = [NSString stringWithFormat:@"%@张",object.picture_num];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_imagePageLabel.text];
            [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, object.picture_num.length)];
            _imagePageLabel.attributedText = attributeString;
            _cardDayLabel.text = [NSString stringWithFormat:@"%@天",object.count_day];
            NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:_cardDayLabel.text];
            [attributeString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, object.count_day.length)];
            _cardDayLabel.attributedText = attributeString2;
            _cardSumDayLabel.text = [NSString stringWithFormat:@"%@次",object.trends_num];
            NSMutableAttributedString *attributeString3 = [[NSMutableAttributedString alloc] initWithString:_cardSumDayLabel.text];
            [attributeString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, object.trends_num.length)];
            _cardSumDayLabel.attributedText = attributeString3;
            if ([object.sport_num intValue] >= 10000) {
                object.sport_num = [NSString stringWithFormat:@"%d",[object.sport_num intValue] / 10000];
                _ConsumptionLabel.text = [NSString stringWithFormat:@"%@万大卡",object.sport_num];
                NSMutableAttributedString *attributeString5 = [[NSMutableAttributedString alloc] initWithString:_ConsumptionLabel.text];
                [attributeString5 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, object.sport_num.length + 1)];
                _ConsumptionLabel.attributedText = attributeString5;
            } else {
                _ConsumptionLabel.text = [NSString stringWithFormat:@"%@大卡",object.sport_num];
                NSMutableAttributedString *attributeString4 = [[NSMutableAttributedString alloc] initWithString:_ConsumptionLabel.text];
                [attributeString4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, object.sport_num.length)];
                _ConsumptionLabel.attributedText = attributeString4;
            }
            
            [object.sex isEqualToString:@"1"] ? [_infoSexImage setImage:[UIImage imageNamed:@"info_man_sex.png"]] : [_infoSexImage setImage:[UIImage imageNamed:@"info_sex_women.png"]];
            
            //[object.picture_num isEqualToString:@"0"] ? _tableView.hidden = YES : _tableView.hidden == NO;
            
//            [_headImage setImageWithURL:[NSURL URLWithString:[Util urlPhoto:object.portrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
            [_headImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Util urlZoomPhoto:object.portrait]]] placeholderImage:[UIImage imageNamed:@"default_headportrait"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                UIImage *effectImage = [image applyLightEffect];
                [_headImage setImage:image];
                [_headBackgroundImage setImage:effectImage];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
            switch ([object.flag intValue]) {
                case 1:
                    [_VariableButton setBackgroundImage:[UIImage imageNamed:@"add_attention_button"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [_VariableButton setBackgroundImage:[UIImage imageNamed:@"mutual_concern"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [_VariableButton setBackgroundImage:[UIImage imageNamed:@"add_attention_button"] forState:UIControlStateNormal];
                    break;
                case 4:
                    [_VariableButton setBackgroundImage:[UIImage imageNamed:@"has_been_concerned"] forState:UIControlStateNormal];
                    break;
//                case 5:
//                    [_VariableButton setBackgroundImage:[UIImage imageNamed:@"edit_info_data"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
    }];
}

#pragma mark request

- (void)initRefresh{
    [self.tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_currentIndex == 1) {
            _limit = 0;
            [self fetchRecord];
        } else if (_currentIndex == 2){
            _collectionLimit = 0;
            [self fetchCollectionList];
        } else {
            _courseTrendsPage = 1;
            if (_friendid) {
                [self fetchUserCourseTrends];
            } else {
                [self fetchMyCourseTrends];
            }
        }
        
    }]];
    [self.tableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentIndex == 1) {
            [self fetchRecord];
        } else if (_currentIndex == 2){
            [self fetchCollectionList];
        } else {
            if (_friendid) {
                [self fetchUserCourseTrends];
            } else {
                [self fetchMyCourseTrends];
            }
        }
        
    }]];
}
- (void)fetchMyCourseTrends {
    [UserCourseTrendModel fetchMyCourseTrends:_courseTrendsPage handler:^(id object, NSString *msg) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *limitTempModel = [LimitResultModel new];
            limitTempModel = object;
            if (_courseTrendsPage ==1) {
                _courseTrendsArray = [limitTempModel.result mutableCopy];
            } else {
                NSMutableArray *temArray = [NSMutableArray arrayWithArray:_courseTrendsArray];
                [temArray addObjectsFromArray:limitTempModel.result];
                _courseTrendsArray = temArray;
            }
            [_tableView reloadData];
            BOOL haveMore = limitTempModel.haveMore;
            if (haveMore) {
                _courseTrendsPage = limitTempModel.page;
                _tableView.footer.hidden = NO;
            } else {
                [_tableView.footer noticeNoMoreData];
                _tableView.footer.hidden = YES;
            }
        }
    }];
}
- (void)fetchUserCourseTrends {
    [UserCourseTrendModel fetchUserCourseTrends:_courseTrendsPage otherId:_friendid handler:^(id object, NSString *msg) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *limitTempModel = [LimitResultModel new];
            limitTempModel = object;
            if (_courseTrendsPage ==1) {
                _courseTrendsArray = [limitTempModel.result mutableCopy];
            } else {
                NSMutableArray *temArray = [NSMutableArray arrayWithArray:_courseTrendsArray];
                [temArray addObjectsFromArray:limitTempModel.result];
                _courseTrendsArray = temArray;
            }
            [_tableView reloadData];
            BOOL haveMore = limitTempModel.haveMore;
            if (haveMore) {
                _courseTrendsPage = limitTempModel.page;
                _tableView.footer.hidden = NO;
            } else {
                [_tableView.footer noticeNoMoreData];
                _tableView.footer.hidden = YES;
            }
        }
    }];
}
- (void)fetchRecord {
    [ClockInInforModel getclockMessgeWithFrendid:_friendid WithLimit:_limit handler:^(id object, NSString *msg) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *limitModel = [LimitResultModel new];
            limitModel = object;
            if (_limit == 0) {
                _members = [limitModel.result mutableCopy];
            }else {
                NSMutableArray *temArray = [NSMutableArray arrayWithArray:_members];
                [temArray addObjectsFromArray:limitModel.result];
                _members = temArray;
            }
            _dataMutableArray = [NSMutableArray array];
            _memberArray = [NSMutableArray arrayWithArray:_members];
            for (int i = 0; i < _memberArray.count; i++) {
                ClockInInforModel *clockInInforModel = _memberArray[i];
                NSString *deteStr = [clockInInforModel.created_time componentsSeparatedByString:@" "][0];
                NSMutableArray *tempArray = [NSMutableArray array];
                [tempArray addObject:clockInInforModel];
                for (int j = i+1; j<_memberArray.count; j ++) {
                    ClockInInforModel *clockInInforModel2 =_memberArray[j];
                    NSString *deteStr2 = [clockInInforModel2.created_time componentsSeparatedByString:@" "][0];
                    if ([deteStr isEqual:deteStr2]) {
                        [tempArray addObject:clockInInforModel2];
                        [_memberArray removeObjectAtIndex:j];
                        j = j - 1;
                    }
                }
                [_dataMutableArray addObject:tempArray];
            }
            [_tableView reloadData];
            BOOL _haveMore = limitModel.haveMore;
            if (_haveMore) {
                _limit = limitModel.limit;
                _tableView.footer.hidden = NO;
            } else {
                [_tableView.footer noticeNoMoreData];
                _tableView.footer.hidden = YES;
            }
        }
    }];
}
- (void)fetchCollectionList {
    [DrysalteryModel drysalteryCollectionListWith:_collectionLimit friendId:_friendid handler:^(id object, NSString *msg) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *limitModel = [LimitResultModel new];
            limitModel = object;
            if (_collectionLimit == 0) {
                _collectionArray = [limitModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_collectionArray mutableCopy];
                [tempArray addObjectsFromArray:limitModel.result];
                _collectionArray = tempArray;
            }
            [_tableView reloadData];
            if (limitModel.haveMore) {
                _collectionLimit = limitModel.limit;
                _tableView.footer.hidden = NO;
            } else {
                [_tableView.footer noticeNoMoreData];
                _tableView.footer.hidden = YES;
            }
        }
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_currentIndex == 1) {
        if (_dataMutableArray.count == 0) {
            return 1;
        } else {
            return _dataMutableArray.count;
        }
    } else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currentIndex == 1) {
        if (_dataMutableArray.count == 0) {
            return 0;
        } else {
            NSArray *tempArray = _dataMutableArray[section];
            return tempArray.count;
        }

    } else if (_currentIndex == 2){
        return _collectionArray.count;
    } else {
        return _courseTrendsArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ( _currentIndex == 1) {
        if (_dataMutableArray.count == 0) {
            return 150;
        } else {
            return 52;
        }
    } else if (_currentIndex == 2) {
        if (_collectionArray.count == 0){
            return 150;
        } else {
            return 0;
        }
    } else {
        if (_courseTrendsArray.count == 0) {
            return 150;
        } else {
            return 0;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    if (_currentIndex == 1) {
        if (_dataMutableArray.count == 0) {
            headerView.frame = CGRectMake(0, 0, 0, 150);
            headerView.backgroundColor = [UIColor clearColor];
            UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 20)];
            emptyLabel.font = [UIFont systemFontOfSize:14];
            emptyLabel.textAlignment = NSTextAlignmentCenter;
            emptyLabel.textColor = [UIColor grayColor];
            emptyLabel.text = @"你还没有记录";
            [headerView addSubview:emptyLabel];
            UILabel *emptyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 20)];
            emptyLabel2.font = [UIFont systemFontOfSize:14];
            emptyLabel2.textAlignment = NSTextAlignmentCenter;
            emptyLabel2.textColor = [UIColor grayColor];
            emptyLabel2.text = @"点击下方+号添加";
            [headerView addSubview:emptyLabel2];
            
        } else {
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 52);
            headerView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 2, 52)];
            lineLabel.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
            [headerView addSubview:lineLabel];
            
            UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 23, 6, 6)];
            pointLabel.backgroundColor = [UIColor whiteColor];
            pointLabel.layer.masksToBounds = YES;
            pointLabel.layer.cornerRadius = 3.0;
            pointLabel.layer.borderWidth = 0.5;
            pointLabel.layer.borderColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0].CGColor;
            [headerView addSubview:pointLabel];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 100, 52)];
            timeLabel.font = [UIFont systemFontOfSize:12];
            timeLabel.textColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
            NSArray *tempArr = _dataMutableArray[section];
            ClockInInforModel *tempModel = tempArr[0];
            NSString *dateString = tempModel.created_time;
            NSDate *createDate = [Util getTimeDate:dateString];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:SS"];
            NSString *tempString = [dateFormatter stringFromDate:createDate];
            timeLabel.text = [tempString substringWithRange:NSMakeRange(5, 6)];
            [headerView addSubview:timeLabel];
        }
        
    } else {
        headerView.frame = CGRectMake(0, 0, 0, 150);
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 20)];
        emptyLabel.font = [UIFont systemFontOfSize:14];
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.textColor = [UIColor grayColor];
        [headerView addSubview:emptyLabel];
        UILabel *emptyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 20)];
        emptyLabel2.font = [UIFont systemFontOfSize:14];
        emptyLabel2.textAlignment = NSTextAlignmentCenter;
        emptyLabel2.textColor = [UIColor grayColor];
        [headerView addSubview:emptyLabel2];
        if (_currentIndex == 2) {
            emptyLabel.text = @"你还没有收藏";
            emptyLabel2.text = @"去干货里面看看吧";
        } else {
            emptyLabel.text = @"你还没有参加课程";
            emptyLabel2.text = @"去训练里面看看吧";
        }
    }
    
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentIndex == 1) {
//        InformationTableViewCell *informationcell = [tableView dequeueReusableCellWithIdentifier:@"informationCell" forIndexPath:indexPath];
//        informationImageModel *model1 = _members[indexPath.row * 3 + 0];
//        [informationcell.leftImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:model1.trendpicture]] placeholderImage:[UIImage imageNamed:@"default_image"]];
//        informationcell.centerImage.hidden = YES;
//        informationcell.rightImage.hidden = YES;
//        if (indexPath.row * 3 + 1 <= _members.count-1) {
//            informationcell.centerImage.hidden = NO;
//            informationImageModel *model2 = _members[indexPath.row * 3 + 1];
//            [informationcell.centerImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:model2.trendpicture]] placeholderImage:[UIImage imageNamed:@"default_image"]];
//        }
//        if (indexPath.row * 3 + 2 <= _members.count-1){
//            informationcell.rightImage.hidden = NO;
//            informationImageModel *model3 = _members[indexPath.row * 3 + 2];
//            [informationcell.rightImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:model3.trendpicture]] placeholderImage:[UIImage imageNamed:@"default_image"]];
//        }
//        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        return informationcell;
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
        NSArray *dataArray = _dataMutableArray[indexPath.section];
        ClockInInforModel *clockInInfoModel = dataArray[indexPath.row];
        [cell setupContentWithModel:clockInInfoModel];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else if (_currentIndex == 2) {
//        if (!_friendid) {
        DrysalteryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DryCell" forIndexPath:indexPath];
        [cell setupDrysalteryContentWithModel:_collectionArray[indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
//        } else {
//            FriendsGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
//            [cell setupContent:_collectionArray[indexPath.row]];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            return cell;
//        }
        
    } else {
        static NSString *CellIdentifier = @"MyCourseTrendCell";
        MyCourseTrendCell *cell = (MyCourseTrendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        UserCourseTrendModel *tempModel = [UserCourseTrendModel new];
        tempModel = _courseTrendsArray[indexPath.row];
        cell.trendTitleLabel.text = [NSString stringWithFormat:@"已持续挑战%@", tempModel.courseName];
        cell.courseDayLabel.text = [NSString stringWithFormat:@"第%ld天", tempModel.courseDay];
        cell.energyLabel.text = [NSString stringWithFormat:@"%ld千卡", tempModel.calorie];
        NSString *timeString = tempModel.createDate;
        NSTimeInterval time = [timeString doubleValue];
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [formatter stringFromDate: detaildate];
        //NSString *tempString = [Util getDateString:tempDate];
        NSDate *date = [Util getTimeDate:currentDateStr];
        if ([[Util compareDate:date] isEqualToString:@"今天"]) {
            currentDateStr = [currentDateStr substringWithRange:NSMakeRange(11, 5)];
        } else if ([[Util compareDate:date] isEqualToString:@"昨天"]) {
            currentDateStr = [NSString stringWithFormat:@"昨天%@", [currentDateStr substringWithRange:NSMakeRange(11, 5)]];
        } else {
            currentDateStr = [currentDateStr substringWithRange:NSMakeRange(5, 11)];
        }
        cell.trendTimeLabel.text = currentDateStr;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentIndex == 1) {
        NSArray *dataArray = _dataMutableArray[indexPath.section];
        ClockInInforModel *clockInInfoModel = dataArray[indexPath.row];
        CGFloat cellHeight = [[RecordCell new] heightForCell:clockInInfoModel];
        return cellHeight;
    } else if (_currentIndex == 2){
//        if (!_friendid) {
        return (SCREEN_WIDTH - 18) / 302 * 179 + 9;
//        } else {
//            return 38.0;
//        }
    } else {
        return 60;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentIndex == 1) {
        NSArray *dataArray = _dataMutableArray[indexPath.section];
        ClockInInforModel *clockInInfoModel = dataArray[indexPath.row];
        ClockInDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
        detailVC.clockinId = clockInInfoModel.id;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (_currentIndex == 2){
//        if (!_friendid) {
        DrysalterDetailViewController *drysalterDetailView = [[UIStoryboard storyboardWithName:@"DrysalteryDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"DrysalterDetailView"];
        DrysalteryModel *tempModel = _collectionArray[indexPath.row];
        drysalterDetailView.model = tempModel;
        drysalterDetailView.drysalteryId = tempModel.dryId;
        drysalterDetailView.titleStr = tempModel.title;
        [self.navigationController pushViewController:drysalterDetailView animated:YES];
//        } else {
//            
//        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark notify
- (void)deleteClick:(NSNotification *)notify{
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)notify.object];
    NSInteger senderTag = [notify.userInfo[@"SENDERTAG"] intValue];
    if (indexPath.row * 3 + senderTag - 1 <= _members.count-1) {
        ClockInDetailViewController *clockInDetailVc = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInDetailView"];
        informationImageModel *informationImageModel = _members[indexPath.row * 3 + senderTag - 1];
        clockInDetailVc.clockinId = informationImageModel.id;
        [self.navigationController pushViewController:clockInDetailVc animated:YES];
    }
}


#pragma mark buttonClick

- (IBAction)varableButtonClick:(UIButton *)sender {
    if (!_friendid) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIViewController *modiFyDataVc = [[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"EditInformationView"];
        [self.navigationController pushViewController:modiFyDataVc animated:YES];
        
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        switch ([_information.flag intValue]) {
            case 1:{
                [AddAttentionModel addAttentionWithfrendid:_friendid handler:^(id object, NSString *msg) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (msg) {
                        [RBNoticeHelper showNoticeAtViewController:self msg:msg];
                    }else {
                        [_VariableButton setImage:[UIImage imageNamed:@"has_been_concerned"] forState:UIControlStateNormal];
                        _information.flag = @"4";
                    }
                }];
            } break;
            case 2:{
                [AddAttentionModel cancelAttentionWithFriendId:_friendid handler:^(id object, NSString *msg) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (msg) {
                        [RBNoticeHelper showNoticeAtViewController:self msg:msg];
                    }else {
                        [_VariableButton setImage:[UIImage imageNamed:@"add_attention_button"] forState:UIControlStateNormal];
                        _information.flag = @"3";
                    }
                }];
            } break;
            case 3:{
                [AddAttentionModel addAttentionWithfrendid:_friendid handler:^(id object, NSString *msg) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (msg) {
                        [RBNoticeHelper showNoticeAtViewController:self msg:msg];
                    }else {
                        [_VariableButton setImage:[UIImage imageNamed:@"mutual_concern"] forState:UIControlStateNormal];
                        _information.flag = @"2";
                    }
                }];
            } break;
            case 4:{
                [AddAttentionModel cancelAttentionWithFriendId:_friendid handler:^(id object, NSString *msg) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (msg) {
                        [RBNoticeHelper showNoticeAtViewController:self msg:msg];
                    }else {
                        [_VariableButton setImage:[UIImage imageNamed:@"add_attention_button"] forState:UIControlStateNormal];
                        _information.flag = @"1";
                    }
                }];
            } break;
            default:
                break;
        }
    }
    
    
}

- (IBAction)fansButton:(UIButton *)sender {
    FansViewController *fansVc=[[UIStoryboard storyboardWithName:@"Fans" bundle:nil] instantiateViewControllerWithIdentifier:@"fansView"];
    fansVc.frendid = _friendid;
    [self.navigationController pushViewController:fansVc animated:YES];
}

- (IBAction)attentionButton:(id)sender {
    AttentionViewController *attentionVc=[[UIStoryboard storyboardWithName:@"Attention" bundle:nil] instantiateViewControllerWithIdentifier:@"attentionView"];
    attentionVc.frendid = _friendid;
    [self.navigationController pushViewController:attentionVc animated:YES];
}

- (IBAction)returnImfomationClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recordClick:(id)sender {
    _currentIndex = 1;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        _recordImage.image = [UIImage imageNamed:@"mine_record_selected"];
        _collectionImage.image = [UIImage imageNamed:@"mine_collection"];
        _courseTrendsImage.image = [UIImage imageNamed:@"mine_course_record_normal"];
    }];
    [self fetchRecord];
}
- (IBAction)rightButtonClick:(id)sender {
    _currentIndex = 2;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        _recordImage.image = [UIImage imageNamed:@"mine_record"];
        _collectionImage.image = [UIImage imageNamed:@"mine_collection_selected"];
        _courseTrendsImage.image = [UIImage imageNamed:@"mine_course_record_normal"];
    }];
    [self fetchCollectionList];
}
- (IBAction)courseTrendsClick:(id)sender {
    _currentIndex = 3;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        _recordImage.image = [UIImage imageNamed:@"mine_record"];
        _collectionImage.image = [UIImage imageNamed:@"mine_collection"];
        _courseTrendsImage.image = [UIImage imageNamed:@"mine_course_record_pressed"];
    }];
    if (_friendid) {
        [self fetchUserCourseTrends];
    } else {
        [self fetchMyCourseTrends];
    }
}
- (IBAction)settingButtonClick:(id)sender {
    PersonalViewController *personalView = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalInfoView"];
    [self.navigationController pushViewController:personalView animated:YES];
}

- (UIView *)titleViewForTabbarNav {
    return nil;
}

- (NSString *)titleForTabbarNav {
    if (!_friendid) {
        return @"我的主页";
    } else {
        return nil;
    }
}

-(NSArray *)leftButtonsForTabbarNav {
    return nil;
}

- (NSArray *)rightButtonsForTabbarNav{
    if (!_friendid) {
        UIBarButtonItem *addFriendButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mine_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonClick:)];
        return @[addFriendButton];
    } else {
        return nil;
    }
}

@end
