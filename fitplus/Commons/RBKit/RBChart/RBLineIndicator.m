//
//  RBLineIndicator.m
//  fitplus
//
//  Created by 天池邵 on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBLineIndicator.h"

typedef NS_ENUM(NSUInteger, IndicatorArrowSide) {
    Arrow_Left,
    Arrow_Right,
};

static NSInteger const TitleLabelTag = 908;
static NSInteger const ValueLabelTag = 808;


@interface RBLineIndicator ()
@property (assign, nonatomic) IndicatorArrowSide arrowSide;
@property (strong, nonatomic) UIView *labelContainerView;
@property (copy, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSArray *values;

@end

@implementation RBLineIndicator

- (UIView *)labelContainerView {
    if (!_labelContainerView) {
        _labelContainerView = [[UIView alloc] init];
        _labelContainerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelContainerView];
    }
    return _labelContainerView;
}

- (void)setupTitles:(NSArray *)titles values:(NSArray *)values {
    self.backgroundColor = [UIColor clearColor];
    _titles = titles;
    _values = values;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    CGRect rectFrame = CGRectZero;
    if (_arrowSide == Arrow_Left) {
        [bezierPath moveToPoint: CGPointMake(0, 7)];
        [bezierPath addLineToPoint: CGPointMake(6, 4)];
        [bezierPath addLineToPoint: CGPointMake(6, 10)];
        [bezierPath addLineToPoint: CGPointMake(0, 7)];
        
        rectFrame = CGRectMake(6, 0, CGRectGetWidth(rect) - 6, CGRectGetHeight(rect));
    } else {
        [bezierPath moveToPoint:CGPointMake(CGRectGetWidth(rect), 7)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - 6, 4)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - 6, 10)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 7)];
        
        rectFrame = CGRectMake(0, 0, CGRectGetWidth(rect) - 6, CGRectGetHeight(rect));
    }
    
    [bezierPath closePath];
    [[UIColor colorWithWhite:0.000 alpha:0.300] setFill];
    [bezierPath fill];
    
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:rectFrame];
    [[UIColor colorWithWhite:0.000 alpha:0.300] setFill];
    [rectanglePath fill];
}

- (void)showInView:(UIView *)view atPosition:(CGPoint)point {
    _touchIdentifier = [[NSDate date] timeIntervalSince1970];
    [self setupLabelsBeforeShowAtPoint:point];
    [view addSubview:self];
}

- (void)setupLabelsBeforeShowAtPoint:(CGPoint)point {
    for (UIView *view in self.labelContainerView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat maxWidth = 0;
    CGFloat height = 0;
    for (int i = 0; i < _titles.count; i ++) {
        NSString *title = _titles[i];
        NSString *value = [NSString stringWithFormat:@"%@", _values[i]];
        UIFont *labelFont = [UIFont systemFontOfSize:10];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : labelFont}];
        CGSize valueSize = [value sizeWithAttributes:@{NSFontAttributeName : labelFont}];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3 + (23 + 5) * i, titleSize.width, 10)];
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), valueSize.width, 10)];
        titleLabel.font = labelFont;
        valueLabel.font = labelFont;
        titleLabel.text = title;
        valueLabel.text = value;
        UIColor *labelColor = [UIColor whiteColor];
        titleLabel.textColor = labelColor;
        valueLabel.textColor = labelColor;
        
        titleLabel.tag = i + TitleLabelTag;
        valueLabel.tag = i + ValueLabelTag;
        
        [self.labelContainerView addSubview:titleLabel];
        [self.labelContainerView addSubview:valueLabel];
        
        if (titleSize.width > valueSize.width) {
            maxWidth = maxWidth < titleSize.width ? titleSize.width : maxWidth;
        } else {
            maxWidth = maxWidth < valueSize.width ? valueSize.width : maxWidth;
        }
        
        if (i == _titles.count - 1) {
            height = CGRectGetMaxY(valueLabel.frame) + 3;
        }
    }
    CGFloat frameWidth = maxWidth + 10 + 6;
    if ((point.x  + frameWidth) > CGRectGetWidth([UIScreen mainScreen].bounds)) {
        _arrowSide = Arrow_Right;
        self.frame = CGRectMake(point.x - frameWidth - .5 , 0, frameWidth, height);
    } else {
        _arrowSide = Arrow_Left;
        self.frame = CGRectMake(point.x + .5, 0, frameWidth, height);
    }
    self.labelContainerView.frame = CGRectMake(5 + (_arrowSide == Arrow_Left ? 6 : 0), 0, maxWidth + 10, height);
    [self setNeedsDisplay];
}

@end
