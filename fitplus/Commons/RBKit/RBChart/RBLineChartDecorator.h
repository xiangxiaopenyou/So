//
//  RBLineChartDecorator.h
//  RBChart
//
//  Created by Shao.Tc on 15/7/5.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBChartDefines.h"

@interface RBLineChartDecorator : NSObject 
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (assign, nonatomic) CGFloat leading;

- (instancetype)initWithHandler:(RBChartInitHandler)handler;

- (void)drawLineInMiddle:(CGSize)size;
@end
