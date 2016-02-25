//
//  CamberView.m
//  fitplus
//
//  Created by 天池邵 on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CamberView.h"

@implementation CamberView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    CGFloat scale = CGRectGetWidth(rect) / 320;
    UIBezierPath* linePath = UIBezierPath.bezierPath;
    [linePath moveToPoint:CGPointMake(0, 0)];
    [linePath addLineToPoint:CGPointMake(CGRectGetWidth(rect) / 2., CGRectGetHeight(rect))];
    [linePath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    
    linePath.lineCapStyle = kCGLineCapSquare;
    linePath.usesEvenOddFillRule = YES;
    
    [[UIColor colorWithRed:0.218 green:0.175 blue:0.260 alpha:1.000] setFill];
    [linePath fill];
}

@end
