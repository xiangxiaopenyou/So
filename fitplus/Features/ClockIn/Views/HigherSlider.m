//
//  HigherSlider.m
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "HigherSlider.h"
#import "RBTitleImageView.h"

@interface HigherSlider ()
@property (strong, nonatomic) RBTitleImageView *popover;
@property (weak, nonatomic) UIImageView *thumbImageView;
@end

@implementation HigherSlider

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIImageView class]] && CGSizeEqualToSize(view.frame.size, self.currentThumbImage.size)) {
                _thumbImageView = (UIImageView *)view;
                break;
            }
        }
    }
    return _thumbImageView;
}

- (RBTitleImageView *)popover {
    if (!_popover) {
        _popover = [[RBTitleImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        [_popover setImage:[UIImage imageNamed:@"slider_popover"]];
        [_popover setTitleColor:[UIColor whiteColor]];
        [_popover setFontSize:12];
        [_popover setTextAlignment:1];
        [_popover setOffset_y:-5];
    }
    
    return _popover;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), 6);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.popover.center = CGPointMake(self.thumbImageView.center.x, self.thumbImageView.center.y - 20);
    [self.popover setTitle:@((NSInteger)(self.value + .5)).stringValue];
    
    
    [self addSubview:self.popover];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.popover.center = CGPointMake(self.thumbImageView.center.x, self.thumbImageView.center.y - 20);
    [self.popover setTitle:@((NSInteger)(self.value + .5)).stringValue];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.popover removeFromSuperview];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self.popover removeFromSuperview];
}

@end
