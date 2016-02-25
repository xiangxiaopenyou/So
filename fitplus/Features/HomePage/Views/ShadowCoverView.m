//
//  ShadowCoverView.m
//  fitplus
//
//  Created by 天池邵 on 15/7/17.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ShadowCoverView.h"

@implementation ShadowCoverView

- (void)drawRect:(CGRect)rect {
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.blackColor];
    [shadow setShadowOffset: CGSizeMake(4.1, -0.1)];
    [shadow setShadowBlurRadius: 55];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor colorWithWhite:0.000 alpha:0.300] setFill];
    [rectanglePath fill];
    
    ////// Rectangle Inner Shadow
    CGContextSaveGState(context);
    UIRectClip(rectanglePath.bounds);
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
    
    CGContextSetAlpha(context, CGColorGetAlpha([shadow.shadowColor CGColor]));
    CGContextBeginTransparencyLayer(context, NULL);
    {
        UIColor* opaqueShadow = [shadow.shadowColor colorWithAlphaComponent: 1];
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [opaqueShadow CGColor]);
        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
        CGContextBeginTransparencyLayer(context, NULL);
        
        [opaqueShadow setFill];
        [rectanglePath fill];
        
        CGContextEndTransparencyLayer(context);
    }
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
}

@end
