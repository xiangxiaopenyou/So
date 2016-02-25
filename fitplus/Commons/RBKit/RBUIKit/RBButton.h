//
//  RBButton.h
//  RainbowKit
//
//  Created by 天池邵 on 15/5/12.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface RBButton : UIButton
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@end
