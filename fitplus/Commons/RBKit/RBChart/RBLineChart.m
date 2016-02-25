//
//  RBLineChart.m
//  RBChart
//
//  Created by Shao.Tc on 15/7/5.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import "RBLineChart.h"
#import "RBLineChartDecorator.h"
#import "RBLineData.h"
#import "RBLineIndicator.h"

@interface RBLineChart ()
@property (strong, nonatomic) RBLineIndicator *indicatorView;
@property (assign, nonatomic) BOOL needDraw;
@property (copy, nonatomic) ChartTouchHandler touchHandler;
@property (assign, nonatomic) NSInteger dataCount;
@property (assign, nonatomic) CGFloat spacing;
@property (strong, nonatomic) UIView *selectedLine;

@end

@implementation RBLineChart

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [RBLineIndicator new];
    }
    
    return _indicatorView;
}

- (UIView *)selectedLine {
    if (!_selectedLine) {
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, .5, CGRectGetHeight(self.frame))];
        _selectedLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:_selectedLine];
    }
    return _selectedLine;
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    [self computeMaxValueAndMaxDataCount];
}

- (void)setMaxValue:(CGFloat)maxValue {
    if (!_autoMaxValue) {
        _maxValue = maxValue;
    }
}

- (void)setAutoMaxValue:(BOOL)autoMaxValue {
    _autoMaxValue = autoMaxValue;
    [self computeMaxValueAndMaxDataCount];
}

- (void)computeMaxValueAndMaxDataCount {
    if (!_datas) {
        return;
    }
    
    _dataCount = 0;
    NSMutableArray *allValues = [NSMutableArray array];
    for (RBLineData *lineData in _datas) {
        [allValues addObjectsFromArray:lineData.values];
        if (lineData.values.count > _dataCount) {
            _dataCount = lineData.values.count;
        }
    }
    
    CGFloat maxValue = 0;
    for (int i = 0; i < (int)(allValues.count / 2. + 0.5); i ++ ) {
        CGFloat value1 = [allValues[i] doubleValue];
        CGFloat value2 = [allValues[allValues.count - i - 1] doubleValue];
        CGFloat tempMaxValue = value1 > value2 ? value1 : value2;
        if (tempMaxValue > maxValue) {
            maxValue = tempMaxValue;
        }
    }
    if (_autoMaxValue) {
        _maxValue = maxValue;
    }
}

- (void)handlerTouch:(ChartTouchHandler)touchHandler {
    _touchHandler = touchHandler;
    self.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches allObjects] firstObject];
    [self chartBeTouched:touch];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches allObjects] firstObject];
    [self chartBeTouched:touch];
}

- (void)chartBeTouched:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self];
    
    NSInteger index = (touchPoint.x - _leading) / self.spacing;
    NSArray *touchedValues = [self showIndicatorAtIndex:index];
    
    !_touchHandler ?: _touchHandler(index, touchedValues);
}

- (NSArray *)showIndicatorAtIndex:(NSInteger)index {
    NSMutableArray *touchedValues = [NSMutableArray array];
    for (RBLineData *lineData in _datas) {
        if (lineData.values.count <= index) {
            continue;
        }
        
        [touchedValues addObject:lineData.values[index]];
    }
    
    [self.indicatorView setupTitles:@[@"运动消耗", @"饮食摄入"] values:touchedValues];
    CGPoint center = CGPointMake(_leading + self.spacing * index, 0);
    [self.indicatorView showInView:self atPosition:center];
    NSInteger touchIdentifier = [[NSDate date] timeIntervalSince1970];
    self.selectedLine.hidden = NO;
    [UIView animateWithDuration:.35 animations:^{
        self.selectedLine.frame = CGRectMake(center.x, 0, .5, CGRectGetHeight(self.selectedLine.frame));
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (touchIdentifier == self.indicatorView.touchIdentifier) {
                [self.indicatorView removeFromSuperview];
                self.selectedLine.hidden = YES;
                self.selectedLine.frame = CGRectMake(0, 0, .5, CGRectGetHeight(self.selectedLine.frame));
            }
        });
    }];
    return touchedValues;
}

- (CGFloat)spacing {
    return (CGRectGetWidth(self.frame) - _leading * 2) / (_dataCount - 1);
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!_needDraw) {
        return;
    }
    for (RBLineData *lineData in _datas) {
        CGPoint lastCenter = CGPointZero;
        
        for (int i = 0; i < lineData.values.count; i++) {
            NSNumber *value = lineData.values[i];
            CGFloat scale = value.floatValue / _maxValue;
            CGPoint center = CGPointMake(_leading + self.spacing * i, (1 - scale) * CGRectGetHeight(self.frame));
            [lineData.lineDecorator drawValuePoint:center];
            [lineData.lineDecorator drawVerticalLine:center height:CGRectGetHeight(rect)];
            
            if (!CGPointEqualToPoint(lastCenter, CGPointZero)) {
                [lineData.lineDecorator drawLineFrom:lastCenter to:center];
            }
            
            lastCenter = center;
        }
        
        [lineData.lineDecorator stokeLinePath];
    }
    
    [_chartDecorator drawLineInMiddle:rect.size];
}

- (void)draw {
    _needDraw = YES;
    [self  setNeedsDisplay];
}


@end

