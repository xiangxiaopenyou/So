//
//  KDTabbarProtocol.h
//  Koudaitong
//
//  Created by ShaoTianchi on 14-9-3.
//  Copyright (c) 2014年 qima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KDTabbarProtocol <NSObject>
@required
- (UIView *)titleViewForTabbarNav;
- (NSArray *)leftButtonsForTabbarNav;
- (NSArray *)rightButtonsForTabbarNav;
@optional
- (NSString *)titleForTabbarNav;
@end
