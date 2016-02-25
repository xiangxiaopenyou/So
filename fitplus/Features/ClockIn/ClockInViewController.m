//
//  ClockInViewController.m
//  fitplus
//
//  Created by 天池邵 on 15/6/25.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInViewController.h"
#import "RecordContentViewController.h"
#import "RBNoticeHelper.h"
#import "GoodSearchTableViewHandler.h"
#import "FoodModel.h"
#import "SportModel.h"
#import "ClockInGoodModel.h"
#import "GoodTagCell.h"
#import "GoodCell.h"
#import "CommonsDefines.h"
#import "NSArray+RBAddition.h"

@interface ClockInViewController ()
@property (copy, nonatomic) NSArray *selectedGoods;
@property (copy, nonatomic) NSArray *rankGoods;
@property (copy, nonatomic) NSArray *usualGoods;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *selectedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedCaloriesLabel;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *goodSerachDisplayController;
@property (strong, nonatomic) GoodSearchTableViewHandler *searchTableHandler;
@property (strong, nonatomic) NSMutableDictionary *goodValues;
@end

@implementation ClockInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    _selectedGoods = [NSArray array];
    _goodValues = [NSMutableDictionary dictionary];
    
    _bottomView.layer.masksToBounds = YES;
    CALayer *borderLayer = [CALayer new];
    borderLayer.frame = CGRectMake(-.5, 0, CGRectGetWidth(_bottomView.frame) + 1, CGRectGetHeight(_bottomView.frame) + .5);
    borderLayer.borderColor = [UIColor colorWithWhite:0.849 alpha:1.000].CGColor;
    borderLayer.borderWidth = 1;
    [_bottomView.layer addSublayer:borderLayer];
    
    if (_type == ClockInType_Sport) {
        _selectedCountLabel.textColor = kSportLabelOrangeColor;
        _selectedCaloriesLabel.textColor = kSportLabelOrangeColor;
    }
    
    self.title = _type == ClockInType_Food ? @"饮食打卡" : @"运动打卡";
    self.tableView.tableFooterView = [UIView new];
    
    [self.searchDisplayController.searchBar setPlaceholder:_type == ClockInType_Food ? @"请输入食物名称" : @"请输入运动名称"];
    
    __weak ClockInViewController *weakSelf = self;
    
    _searchTableHandler = [[GoodSearchTableViewHandler alloc] initWithSearchDisplayController:_goodSerachDisplayController handler:^(ClockInGoodModel *good, NSIndexPath *indexPath) {
        __strong ClockInViewController *strongSelf = weakSelf;
        [strongSelf selectedGood:good isSearch:YES];
    } fetchType:(_type == ClockInType_Food ? Fetch_Food : Fetch_Sport)];
    
    [self getRankGoodsFromServer];
    [self getUsualGoodsFromLocal];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Funcs

- (void)selectedGood:(ClockInGoodModel *)good isSearch:(BOOL)isSearch {
    if ([_selectedGoods containsObject:good]) {
        return;
    }
    
    NSMutableArray *tempFoods = [_selectedGoods mutableCopy];
    [tempFoods addObject:good];
    _selectedGoods = tempFoods;
    
    if (isSearch) {
        [self saveGoodToLocal:good];
        [self getUsualGoodsFromLocal];
    }
    
    _selectedCountLabel.text = @(_selectedGoods.count).stringValue;
    
    [self.tableView reloadData];
}

- (void)deselectGood:(NSInteger)index {
    NSMutableArray *tempGoods = [_selectedGoods mutableCopy];
    ClockInGoodModel *goodModel = tempGoods[index];
    CGFloat calories = [_goodValues[goodModel.goodName][@"calorie"] doubleValue];
    [_goodValues removeObjectForKey:goodModel.goodName];
    [tempGoods removeObjectAtIndex:index];
    
    _selectedGoods = tempGoods;
    _selectedCountLabel.text = @(_selectedCountLabel.text.integerValue - 1).stringValue;
    _selectedCaloriesLabel.text = [NSString stringWithFormat:@"%.1f", [_selectedCaloriesLabel.text doubleValue] - calories];
    [self.tableView reloadData];
}

- (void)saveGoodToLocal:(ClockInGoodModel *)good {
    NSString *cacheSavePath = kCachePath((_type == ClockInType_Food ? CacheUsualFood : CacheUsualSport));
    NSData *cacheData = [NSData dataWithContentsOfFile:cacheSavePath];
    NSMutableArray *newUsualGoods;
    if (cacheData) {
        NSArray *usualGoods = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingAllowFragments error:nil];
        if (!usualGoods) {
            usualGoods = @[];
        }
        newUsualGoods = [usualGoods mutableCopy];
        [newUsualGoods insertObject:[good toDictionary] atIndex:0];
    } else {
        newUsualGoods = [[NSMutableArray alloc] initWithObjects:[good toDictionary], nil];
    }
    NSData *newCacheData = [NSJSONSerialization dataWithJSONObject:newUsualGoods options:NSJSONWritingPrettyPrinted error:nil];
    [newCacheData writeToFile:cacheSavePath atomically:YES];
}

- (void)getUsualGoodsFromLocal {
    NSData *cacheData = [NSData dataWithContentsOfFile:kCachePath((_type == ClockInType_Food ? CacheUsualFood : CacheUsualSport))];
    if (cacheData) {
        NSArray *usualGoods = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingAllowFragments error:nil];
        Class modelClass = (_type == ClockInType_Food ? [FoodModel class] : [SportModel class]);
        _usualGoods = [modelClass setupWithArray:[usualGoods subarrayWithRange:NSMakeRange(0, usualGoods.count > 4 ? 4 : usualGoods.count)]];
    } else {
        _usualGoods = [NSArray array];
    }
}

- (void)getRankGoodsFromServer {
    
    id fetchHandler = ^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:msg];
        } else {
            _rankGoods = object;
            [self.tableView reloadData];
        }
    };
    
    if (_type == ClockInType_Food) {
        [FoodModel fetchGoodRank:fetchHandler];
    } else {
        [SportModel fetchGoodRank:fetchHandler];
    }
}


- (IBAction)save:(id)sender {
    BOOL haveZeroValue = NO;
    
    for (ClockInGoodModel *good in _selectedGoods) {
        if (![_goodValues.allKeys containsObject:good.goodName] || [_goodValues[good.goodName][@"value"] doubleValue] == 0) {
            [RBNoticeHelper showNoticeAtViewController:self msg:[NSString stringWithFormat:@"%@还没有选择数量", good.goodName]];
            haveZeroValue = YES;
            break;
        }
    }
    
    if (haveZeroValue) {
        return;
    }
    if (_selectedGoods.count == 0) {
        [RBNoticeHelper showNoticeAtViewController:self msg:[NSString stringWithFormat:@"你还没有选择%@", _type == ClockInType_Food ? @"食物" : @"运动"]];
        return;
    }
    
    [self performSegueWithIdentifier:@"ClockIn2Record" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ClockIn2Record"]) {
        RecordContentViewController *recordVC = segue.destinationViewController;
        recordVC.selectedGoods = _selectedGoods;
        recordVC.calories = _selectedCaloriesLabel.text;
        recordVC.type = _type;
    }
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _selectedGoods.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 89;
    BOOL isTagCell = [self isTagCellWithRow:indexPath.row];
    if (isTagCell) {
        TagCellType type = (indexPath.row == 0 || indexPath.row == _selectedGoods.count) ? TagCell_Rank : TagCell_Usual;
        cellHeight = [[GoodTagCell new] cellHeightWithGoods:type == TagCell_Rank ? _rankGoods : _usualGoods];
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *GoodCellIdentifier = @"GoodCell";
    static NSString *TagCellIdentifier  = @"GoodTagCell";
    BOOL isTagCell = [self isTagCellWithRow:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:isTagCell ? TagCellIdentifier : GoodCellIdentifier forIndexPath:indexPath];
    if (isTagCell) {
        TagCellType type = (indexPath.row == 0 || indexPath.row == _selectedGoods.count) ? TagCell_Rank : TagCell_Usual;
        [(GoodTagCell *)cell setUpWithGoods:type == TagCell_Rank ? _rankGoods : _usualGoods cellType:type goodType:(_type == ClockInType_Food ? GoodType_Food : GoodType_Sport) handler:^(ClockInGoodModel *good) {
            [self selectedGood:good isSearch:NO];
        }];
    } else {
        ClockInGoodModel *goodModel = _selectedGoods[indexPath.row];
        NSDictionary *goodValue = [_goodValues objectForKey:goodModel.goodName];
        NSInteger value = 0;
        if (goodValue) {
            value = [goodValue[@"value"] integerValue];
        }
        [(GoodCell *)cell setupWithGood:goodModel value:value handler:^(NSInteger value, CGFloat calorie) {
            [self calorieChange:value calorie:calorie index:indexPath.row];
        }];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isTagCell = [self isTagCellWithRow:indexPath.row];
    if (!isTagCell) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deselectGood:indexPath.row];
    }
}

- (void)calorieChange:(NSInteger)value calorie:(CGFloat)calorie index:(NSInteger)index {
    ClockInGoodModel *good = _selectedGoods[index];
    [_goodValues setObject:@{@"value" : @(value), @"calorie" : @(calorie)} forKey:good.goodName];
    CGFloat totalCalorie = 0;
    for (NSString *goodKey in _goodValues.allKeys) {
        totalCalorie += [_goodValues[goodKey][@"calorie"] doubleValue];
    }
    
    _selectedCaloriesLabel.text = [NSString stringWithFormat:@"%.1f", totalCalorie];
}

- (BOOL)isTagCellWithRow:(NSInteger)row {
    BOOL isTagCell = NO;
    if (_selectedGoods.count == 0) {
        isTagCell = YES;
    } else if (row > _selectedGoods.count - 1) {
        isTagCell = YES;
    }
    
    return isTagCell;
}

@end
