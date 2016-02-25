//
//  RBLineDecorator.h
//  RBChart
//
//  Created by Shao.Tc on 15/7/5.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBChartDefines.h"


typedef void(^DrawPointHandler)(CGRect);

@protocol LineDecoratorProtocol <NSObject>

@required
@property (strong, nonatomic) UIBezierPath *linePath;
- (void)drawValuePoint:(CGPoint)center;
- (void)drawLineFrom:(CGPoint)from to:(CGPoint)to;
- (void)stokeLinePath;
@end

@interface RBLineDecorator : NSObject <LineDecoratorProtocol>
@property (assign, nonatomic) CGFloat pointWidth;
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
@property (copy, nonatomic) DrawPointHandler pointDrawer;

- (instancetype)initWithHandler:(RBChartInitHandler)handler;
- (void)drawVerticalLine:(CGPoint)point height:(CGFloat)height;

@end
