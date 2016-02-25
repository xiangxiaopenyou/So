//
//  RBBlockActionSheet.h
//  RainbowKit
//
//  Created by ShaoTianchi on 14/10/30.
//  Copyright (c) 2014年 Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickedBlock) (NSInteger buttonIndex);

@interface RBBlockActionSheet : UIActionSheet
- (instancetype)initWithTitle:(NSString *)title clickBlock:(ClickedBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
