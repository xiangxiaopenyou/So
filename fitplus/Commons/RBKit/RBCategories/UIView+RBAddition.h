//
//  UIView+RBAddition.h
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum : NSUInteger {
//    BorderSide_Top    = 1 << 0,
//    BorderSide_Bottom = 1 << 1,
//    BorderSide_Left   = 1 << 2,
//    BorderSide_Right  = 1 << 3
//} RB_BorderSide;

typedef NS_OPTIONS(NSUInteger, RB_BorderSide) {
    BorderSide_Top = 1 << 0,
    BorderSide_Bottom = 1 << 1,
    BorderSide_Left = 1 << 2,
    BorderSide_Right  = 1 << 3
};

@interface UIView (RBAddition)
- (void)rb_addBorder:(RB_BorderSide)side width:(CGFloat)width color:(UIColor *)color;
@end
