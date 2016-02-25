//
//  RBLabel.h
//  RainbowKit
//
//  Created by 天池邵 on 15/5/12.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface RBTitleImageView : UIImageView
@property (copy, nonatomic) IBInspectable NSString *title;
@property (assign, nonatomic) IBInspectable CGFloat fontSize;
@property (assign, nonatomic) IBInspectable NSInteger textAlignment; // 0 lefe 1 center 2 right
@property (strong, nonatomic) IBInspectable UIColor *titleColor;
@property (assign, nonatomic) IBInspectable CGFloat offset_x;
@property (assign, nonatomic) IBInspectable CGFloat offset_y;
@end
