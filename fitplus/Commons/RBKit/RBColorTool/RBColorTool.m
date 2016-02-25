//
//  RBColorTool.m
//  RainbowKit
//
//  Created by 天池邵 on 15/3/17.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "RBColorTool.h"

@implementation RBColorTool

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
