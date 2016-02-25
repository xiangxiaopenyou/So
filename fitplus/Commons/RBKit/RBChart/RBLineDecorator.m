//
//  RBLineDecorator.m
//  RBChart
//
//  Created by Shao.Tc on 15/7/5.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import "RBLineDecorator.h"

@interface RBLineDecorator ()
@property (strong, nonatomic) UIColor *pointFillColor;
@end

@implementation RBLineDecorator
@synthesize linePath = _linePath;
- (instancetype)initWithHandler:(RBChartInitHandler)handler {
    self = [super init];
    if (self) {
        !handler ?: handler(self);
    }
    
    return self;
}

- (void)drawValuePoint:(CGPoint)center {
    !_pointDrawer ?: _pointDrawer(CGRectMake(center.x - _pointWidth / 2., center.y - _pointWidth / 2., _pointWidth, _pointWidth));
}

- (void)drawVerticalLine:(CGPoint)point height:(CGFloat)height {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(point.x, 0)];
    [linePath addLineToPoint:CGPointMake(point.x, height)];
    linePath.lineCapStyle = kCGLineCapRound;
    [[UIColor colorWithWhite:1.000 alpha:0.250] setStroke];
    linePath.lineWidth = .5;
    [linePath stroke];
    
}

- (void)drawLineFrom:(CGPoint)from to:(CGPoint)to {
    if (!self.linePath) {
        self.linePath = [UIBezierPath bezierPath];
    }
    
    CGFloat dx = to.x - from.x;
    CGFloat dy = to.y - from.y;
    CGFloat r = _pointWidth / 2.;
    CGFloat distance = sqrt(pow(dx, 2) + pow(dy, 2));
    [self.linePath moveToPoint: CGPointMake(from.x + (dx * r) / distance,
                                         from.y + (dy * r) / distance)];
    [self.linePath addLineToPoint: CGPointMake(to.x - (dx * r) / distance,
                                            to.y - (dy * r) / distance)];
//    kSolidRound(self.linePath);
}

- (void)stokeLinePath {
    if (self.linePath) {
        self.linePath.lineCapStyle = kCGLineCapRound;
        [_lineColor setStroke];
        self.linePath.lineWidth = _lineWidth;
        [self.linePath stroke];
    }
}

@end
