//
//  RBGlobal.h
//  RainbowKit
//
//  Created by 天池邵 on 15/3/30.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBGlobal : NSObject
+ (instancetype)sharedInstance;
- (NSDateFormatter *)formatterWithFormatStr:(NSString *)formatStr timeZone:(NSString *)timeZone;
@end
