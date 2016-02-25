//
//  DragButton.m
//  fitplus
//
//  Created by xlp on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DragButton.h"
#import "CommonsDefines.h"

@implementation DragButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _tagImageRight = [UIImage imageNamed:@"tag_right"];
        _tagImageLeft = [UIImage imageNamed:@"tag_left"];
        UIEdgeInsets insets_right = UIEdgeInsetsMake(0, 52, 0, 10);
        UIEdgeInsets insets_left = UIEdgeInsetsMake(0, 10, 0, 52);
        _tagImageRight = [_tagImageRight resizableImageWithCapInsets:insets_right resizingMode:UIImageResizingModeStretch];
        _tagImageLeft = [_tagImageLeft resizableImageWithCapInsets:insets_left resizingMode:UIImageResizingModeStretch];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    _beginPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - _beginPoint.x;
    float offsetY = nowPoint.y - _beginPoint.y;
    
    float topHeight = (CGRectGetHeight(self.superview.frame) - SCREEN_WIDTH) / 2;
    
    CGPoint newcenter = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    if (newcenter.x < self.frame.size.width/2){
        newcenter.x = self.frame.size.width/2;
    }
    if (newcenter.x > [[UIScreen mainScreen] bounds].size.width - self.frame.size.width/2) {
        newcenter.x = [[UIScreen mainScreen] bounds].size.width - self.frame.size.width/2;
    }
    if (newcenter.y < self.frame.size.height/2 + topHeight) {
        newcenter.y = self.frame.size.height/2 + topHeight;
    }
    if (newcenter.y > SCREEN_WIDTH + topHeight - self.frame.size.height/2) {
//        newcenter.y = self.superview.frame.size.height - self.frame.size.height/2;
        newcenter.y = SCREEN_WIDTH + topHeight - self.frame.size.height/2;
    }
    self.center = newcenter;
    
    if (self.center.x > SCREEN_WIDTH/2 + 10) {
        [self setBackgroundImage:_tagImageRight forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    else {
        [self setBackgroundImage:_tagImageLeft forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
