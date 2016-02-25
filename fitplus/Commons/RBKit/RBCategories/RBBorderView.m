//
//  RBBorderView.m
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBBorderView.h"

@implementation RBBorderView
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:rect];
    [_borderColor setStroke];
    rectanglePath.lineWidth = _borderWidth;
    [rectanglePath stroke];
}
@end
