//
//  PhotoEditViewController.h
//  fitplus
//
//  Created by 天池邵 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditDoneHandler)(UIImage *image, NSArray *tags, UIViewController *editer);

@interface PhotoEditViewController : UIViewController
@property (copy, nonatomic) EditDoneHandler handler;
@property (strong, nonatomic) UIImage *inputImage;
@end

