//
//  UIImage+PhotoAddition.h
//  RainbowKit
//
//  Created by ShaoTianchi on 14-6-14.
//  Copyright (c) 2014年 Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PhotoAddition)
+ (UIImage *)rb_fixOrientationForImage:(UIImage *)image;
+ (UIImage *)rb_fixOrientationForVefifierWithImage:(UIImage *)image;
- (UIImage *)rb_scaleImageToSize:(CGSize)size;
- (UIImage *)rb_cutImageWithRect:(CGRect)cutRect;
+ (UIImage *)rb_smallTheImage:(UIImage *)image;
+ (NSData *)rb_smallTheImageBackData:(UIImage *)image;
+ (UIImage *)rb_imageFromView:(UIView *)view;
- (UIImage *)rb_cutImageWithViewSize:(CGSize)viewSize;
- (UIImage *)rb_geometricScalingToSize:(CGSize)size;
@end
