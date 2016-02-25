//
//  CircleProgressView.m
//  fitplus
//
//  Created by xlp on 15/10/8.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "CircleProgressView.h"

@implementation CircleProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.lineWidth = 4.0;
    self.backColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) radius:(CGRectGetWidth(self.bounds) - self.lineWidth) / 2 startAngle:(CGFloat)- M_PI_2 endAngle:(CGFloat)(1.5 * M_PI) clockwise:YES];
    [self.backColor setStroke];
    circlePath.lineWidth = self.lineWidth;
    [circlePath stroke];
    if (_progressFloat) {
        self.progressColor = [UIColor colorWithRed:87/255.0 green:172/255.0 blue:184/255.0 alpha:1.0];
        UIBezierPath *progressCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) radius:(CGRectGetWidth(self.bounds) - self.lineWidth) / 2 startAngle:(CGFloat)- M_PI_2 endAngle:(CGFloat)(- M_PI_2 + self.progressFloat * 2 * M_PI) clockwise:YES];
        [self.progressColor setStroke];
        progressCirclePath.lineWidth = self.lineWidth;
        [progressCirclePath stroke];
    }
}
- (void)updateProgressCircle:(CGFloat)progress {
    _progressFloat = progress;
    [self setNeedsDisplay];
}
- (void)stop {
    
}

@end
