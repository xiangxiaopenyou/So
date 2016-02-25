//
//  NSString+TimeAddition.h
//  Koudaitong
//
//  Created by ShaoTianchi on 14-9-16.
//  Copyright (c) 2014年 rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBGlobal.h"

@interface NSString (TimeAddition)
+ (NSString *)yu_timeWithTimeInt:(NSTimeInterval)timeSeconds timeFormat:(NSString *)timeFormatStr timeZome:(NSString *)timeZoneStr;
+ (NSString *)yu_daysFromTodayTo:(NSInteger)timeSeconds;
@end
