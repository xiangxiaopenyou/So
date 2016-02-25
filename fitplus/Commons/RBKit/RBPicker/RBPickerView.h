//
//  RBPickerView.h
//  Coach
//
//  Created by 天池邵 on 15/6/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBPickerView : UIView
- (void)setPicker:(UIView *)picker handler:(void(^)(NSInteger index))handler buttonTitles:(NSString *)titles, ...;
@end
