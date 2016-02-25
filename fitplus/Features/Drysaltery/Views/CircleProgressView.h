//
//  CircleProgressView.h
//  fitplus
//
//  Created by xlp on 15/10/8.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView
@property (assign, nonatomic) CGFloat progressFloat;
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIColor *progressColor;

- (void)updateProgressCircle:(CGFloat)progress;
- (void)stop;

@end
