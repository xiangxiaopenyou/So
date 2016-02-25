//
//  FoodSearchTableViewHandler.h
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoodModel, ClockInGoodModel;

typedef enum : NSUInteger {
    Fetch_Food,
    Fetch_Sport,
} FetchType;

typedef void(^TableViewSelectedHandler)(ClockInGoodModel *good, NSIndexPath *indexPath);

@interface GoodSearchTableViewHandler : NSObject <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
- (void)setDataSource:(NSArray *)dataSource;
- (void)appendDataSource:(NSArray *)dataSource;
- (instancetype)initWithSearchDisplayController:(UISearchDisplayController *)searchDisplayController handler:(TableViewSelectedHandler)handler fetchType:(FetchType)fetchType;
@end
