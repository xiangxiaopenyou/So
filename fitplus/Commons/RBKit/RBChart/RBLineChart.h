//
//  RBLineChart.h
//  RBChart
//
//  Created by Shao.Tc on 15/7/5.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RBLineChartDecorator;
typedef void(^ChartTouchHandler)(NSInteger index, NSArray *values);

@interface RBLineChart : UIView
@property (copy, nonatomic) NSArray *datas;
@property (assign, nonatomic) CGFloat maxValue;
@property (assign, nonatomic) CGFloat leading;
@property (assign, nonatomic) BOOL autoMaxValue;
@property (assign, nonatomic) BOOL needHandlerTouch;
@property (strong, nonatomic) RBLineChartDecorator *chartDecorator;

- (NSArray *)showIndicatorAtIndex:(NSInteger)index;

- (void)handlerTouch:(ChartTouchHandler)touchHandler;
- (void)draw;
@end
