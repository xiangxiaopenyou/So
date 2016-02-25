//
//  RBLineChartDecorator.m
//  RBChart
//
//  Created by Shao.Tc on 15/7/5.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import "RBLineChartDecorator.h"

@implementation RBLineChartDecorator

- (instancetype)initWithHandler:(RBChartInitHandler)handler {
    self = [super init];
    if (self) {
        !handler ?: handler(self);
    }
    
    return self;
}

- (void)drawLineInMiddle:(CGSize)size {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, size.height / 2.)];
    [linePath addLineToPoint:CGPointMake(size.width, size.height / 2.)];
    
    linePath.lineCapStyle = kCGLineCapRound;
    [[UIColor colorWithWhite:1.000 alpha:0.250] setStroke];
    linePath.lineWidth = .5;
    [linePath stroke];
}

@end
