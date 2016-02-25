//
//  DragButton.h
//  fitplus
//
//  Created by xlp on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragButton : UIButton
@property (assign, nonatomic) CGPoint beginPoint;
@property (strong, nonatomic) UIImage *tagImageRight;
@property (strong, nonatomic) UIImage *tagImageLeft;

@property (assign, nonatomic) BOOL dragEnable;

@end
