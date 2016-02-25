//
//  RBColorTool.h
//  RainbowKit
//
//  Created by 天池邵 on 15/3/17.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kRBColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RBColorTool : NSObject
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
