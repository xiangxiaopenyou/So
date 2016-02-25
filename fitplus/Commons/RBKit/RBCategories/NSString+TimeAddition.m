//
//  NSString+TimeAddition.m
//  Koudaitong
//
//  Created by ShaoTianchi on 14-9-16.
//  Copyright (c) 2014年 rainbow. All rights reserved.
//

#import "NSString+TimeAddition.h"

NSString *const AvatarBaseUrl = @"http://121.41.114.70:8889/Public/Uploads/HeadImg/";

@implementation NSString (TimeAddition)

+ (NSString *)yu_timeWithTimeInt:(NSTimeInterval)timeSeconds timeFormat:(NSString *)timeFormatStr timeZome:(NSString *)timeZoneStr {
    NSString *date_string;
    NSDate *time_str;
    if ( timeSeconds > 0) {
        time_str = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    } else {
        time_str = [[NSDate alloc] init];
    }
    if ( timeFormatStr == nil) {
        date_string = [NSString stringWithFormat:@"%ld", (long)[time_str timeIntervalSince1970]];
    } else {
        NSDateFormatter *date_format_str = [[RBGlobal sharedInstance] formatterWithFormatStr:timeFormatStr timeZone:timeZoneStr];
        date_string = [date_format_str stringFromDate:time_str];
    }
    return date_string;
}

+ (NSString *)yu_daysFromTodayTo:(NSInteger)timeSeconds {
    NSDateFormatter *dateFormatter = [[RBGlobal sharedInstance] formatterWithFormatStr:@"yyyy-MM-dd" timeZone:nil];
    NSString *joinDate = [NSString yu_timeWithTimeInt:timeSeconds timeFormat:@"yyyy-MM-dd" timeZome:nil];
    NSInteger days_second = [[NSDate date] timeIntervalSinceDate:[dateFormatter dateFromString:joinDate]];
    NSInteger days = days_second / 24 / 3600;
    return [NSString stringWithFormat:@"%li", (long)days];
}

@end

