//
//  FoodRankCell.m
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "GoodTagCell.h"
#import "FoodModel.h"
#import "ClockInGoodModel.h"
#import "RBColorTool.h"

@interface GoodTagCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (copy, nonatomic) TagGoodChooseHandler handler;
@property (copy, nonatomic) NSArray *goods;

@end

@implementation GoodTagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)titleWithCellType:(TagCellType)cellType goodType:(GoodType)goodType {
    NSString *title;
    if (cellType == TagCell_Rank) {
        if (goodType == GoodType_Food) {
            title = @"大家经常吃";
        } else {
            title = @"大家经常做";
        }
    } else {
        title = @"最近搜索";
    }
    
    return title;
}

- (NSString *)emptyMessageWithCellType:(TagCellType)cellType goodType:(GoodType)goodType {
    NSString *emptyMessage;
    if (cellType == TagCell_Rank) {
        if (goodType == GoodType_Food) {
            emptyMessage = @"暂时还没有";
        } else {
            emptyMessage = @"暂时还没有";
        }
    } else {
        emptyMessage = @"你还没有搜索";
    }
    
    return emptyMessage;
}

- (void)setUpWithGoods:(NSArray *)goods cellType:(TagCellType)cellType goodType:(GoodType)goodType handler:(TagGoodChooseHandler)handler {
    _handler = handler;
    _titleLabel.text = [self titleWithCellType:cellType goodType:goodType];
    _goods = goods;
    if (goods.count == 0) {
        _emptyLabel.hidden = NO;
        _emptyLabel.text = [self emptyMessageWithCellType:cellType goodType:goodType];
    } else {
        _emptyLabel.hidden = YES;
        CGFloat lastMaxX = 8;
        CGFloat lineIndex = 0;
        CGFloat baseY = CGRectGetMaxY(_titleLabel.frame) + 5;
        for (ClockInGoodModel *good in goods) {
            UIButton *goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [goodButton setBackgroundImage:[RBColorTool imageWithColor:[UIColor colorWithWhite:0.961 alpha:1.000]] forState:UIControlStateNormal];
            [goodButton setTitleColor:kRBColorFromHex(0x646464) forState:UIControlStateNormal];
            [goodButton setTitle:good.goodName forState:UIControlStateNormal];
            goodButton.titleLabel.font = [UIFont systemFontOfSize:14];
            goodButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [goodButton addTarget:self action:@selector(tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            goodButton.tag = 99 + [goods indexOfObject:good];
            CGSize labelSize = [good.goodName sizeWithAttributes:@{NSFontAttributeName : goodButton.titleLabel.font}];
            labelSize.width += 40;
            if (labelSize.width > 177 ) {
                labelSize.width = 177;
            }
            if (lastMaxX + 14 + labelSize.width > CGRectGetWidth([UIScreen mainScreen].bounds)) {
                lineIndex++;
                lastMaxX = 8;
            }
            
            goodButton.frame = CGRectMake(lastMaxX + 6, lineIndex * (36 + 5) + baseY, labelSize.width, 36);
            lastMaxX = CGRectGetMaxX(goodButton.frame);
            
            [self.contentView addSubview:goodButton];
        }
    }
}

- (CGFloat)cellHeightWithGoods:(NSArray *)goods {
    CGFloat cellHeight = 0;
    if (goods.count == 0) {
        cellHeight = 89.;
    } else {
        CGFloat lastMaxX = 8;
        CGFloat lineIndex = 0;
        CGFloat baseY = 26 + 9;
        for (ClockInGoodModel *good in goods) {
            UIButton *goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
            goodButton.backgroundColor = [UIColor lightGrayColor];
            [goodButton setTitle:good.goodName forState:UIControlStateNormal];
            goodButton.titleLabel.font = [UIFont systemFontOfSize:14];
            CGSize labelSize = [good.goodName sizeWithAttributes:@{NSFontAttributeName : goodButton.titleLabel.font}];
            labelSize.width += 40;
            if (labelSize.width > 177 ) {
                labelSize.width = 177;
            }
            if (lastMaxX + 14 + labelSize.width > CGRectGetWidth([UIScreen mainScreen].bounds)) {
                lineIndex++;
                lastMaxX = 8;
            }
            
            goodButton.frame = CGRectMake(lastMaxX + 6, lineIndex * (36 + 5) + baseY, labelSize.width, 36);
            lastMaxX = CGRectGetMaxX(goodButton.frame);
            cellHeight = CGRectGetMaxY(goodButton.frame) + 15;
        }
    }
    return cellHeight;
}

- (void)tagButtonAction:(UIButton *)button {
    NSInteger index = button.tag - 99;
    !_handler ?: _handler(_goods[index]);
}

@end
