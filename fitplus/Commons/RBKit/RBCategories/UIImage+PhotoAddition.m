//
//  UIImage+PhotoAddition.m
//  RainbowKit
//
//  Created by ShaoTianchi on 14-6-14.
//  Copyright (c) 2014年 Rainbow. All rights reserved.
//

#import "UIImage+PhotoAddition.h"

@implementation UIImage (PhotoAddition)

+ (UIImage *)rb_fixOrientationForImage:(UIImage *)image {
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch (orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)rb_fixOrientationForVefifierWithImage:(UIImage *)image {
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    transform = CGAffineTransformIdentity;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)rb_scaleImageToSize:(CGSize)size {
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

- (UIImage *)rb_cutImageWithRect:(CGRect)cutRect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, cutRect);
    UIGraphicsBeginImageContext(cutRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, cutRect, subImageRef);
    UIImage *cutedImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    if (subImageRef) {
        CFRelease(subImageRef);
    }
    return cutedImage;
}

+ (UIImage *)rb_smallTheImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.);
    if (data.length > 1024 * 1024 * 2) {
        NSData *smallData = UIImageJPEGRepresentation(image, (1024 * 1024 * 2) / data.length * 2);
        if (smallData.length > 1024 * 1024 * 2) {
            return [self rb_smallTheImage:[UIImage imageWithData:smallData]];
        } else {
            return [UIImage imageWithData:smallData];
        }
    } else {
        return image;
    }
}

+ (NSData *)rb_smallTheImageBackData:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.);
    if (data.length > 1024 * 1024 * 2) {
        NSData *smallData = UIImageJPEGRepresentation(image, (1024 * 1024 * 2) / data.length * 2);
        if (smallData.length > 1024 * 1024 * 2) {
            return [self rb_smallTheImageBackData:[UIImage imageWithData:smallData]];
        } else {
            return smallData;
        }
    } else {
        return data;
    }
}

+ (UIImage *)rb_imageFromView:(UIView *)view {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
//    CGContextSetInterpolationQuality(currnetContext, kCGInterpolationHigh);
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)rb_cutImageWithViewSize:(CGSize)viewSize {
    CGFloat defaultRatio = viewSize.width / viewSize.height;
    CGSize imageSize = self.size;
    CGFloat imageRatio = imageSize.width / imageSize.height;
    CGRect cutFrame;
    if (imageRatio > defaultRatio) {
        CGFloat cutWidth = imageSize.height * viewSize.width / viewSize.height;
        cutFrame = CGRectMake((imageSize.width - cutWidth) / 2, 0, cutWidth, imageSize.height);
    } else {
        CGFloat cutHeight = imageSize.width * viewSize.height / viewSize.width;
        cutFrame = CGRectMake(0, (imageSize.height - cutHeight) / 2, imageSize.width, cutHeight);
    }
    
    UIImage *cuttedImage = [self rb_cutImageWithRect:cutFrame];
    return cuttedImage;
}

- (UIImage *)rb_geometricScalingToSize:(CGSize)size {
    if (self.size.width <= size.width) {
        return self;
    }
    CGFloat changeScale = size.width / size.height;
    CGFloat originScale = self.size.width / size.height;
    CGSize newImageSize = CGSizeZero;
    if (originScale > changeScale) {
        // 原图的宽:高 大于 输出尺寸的宽:高，按照宽度来缩放
        newImageSize.width = size.width;
        newImageSize.height = self.size.height * size.width / self.size.width;
    } else {
        // 原图的宽:高 小于 输出尺寸的宽:高，按照高度来缩放
        newImageSize.height = size.height;
        newImageSize.width = self.size.width * size.height / self.size.height;
    }
    
    UIImage *sizedImage = [self rb_scaleImageToSize:newImageSize];
    
    UIGraphicsBeginImageContext(size);
    
    [[UIColor blackColor] setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)] fill];
    
    CGRect rect = CGRectMake((size.width - sizedImage.size.width) / 2, (size.height - sizedImage.size.height) / 2, sizedImage.size.width, sizedImage.size.height);
    [sizedImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *resultImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
