//
//  RBButton.m
//  RainbowKit
//
//  Created by 天池邵 on 15/5/12.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "RBButton.h"

@implementation RBButton

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.masksToBounds = YES;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

@end
