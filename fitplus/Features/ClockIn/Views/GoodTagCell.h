//
//  FoodRankCell.h
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClockInGoodModel;

typedef enum : NSUInteger {
    TagCell_Rank,
    TagCell_Usual,
} TagCellType;

typedef enum : NSUInteger {
    GoodType_Food,
    GoodType_Sport,
} GoodType;

typedef void(^TagGoodChooseHandler)(ClockInGoodModel *good);

@interface GoodTagCell : UITableViewCell
- (void)setUpWithGoods:(NSArray *)goods cellType:(TagCellType)cellType goodType:(GoodType)goodType handler:(TagGoodChooseHandler)handler;
- (CGFloat)cellHeightWithGoods:(NSArray *)goods;
@end
