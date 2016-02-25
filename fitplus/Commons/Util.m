//
//  Util.m
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "Util.h"
#import "RequestManager.h"

@implementation Util
/*
 空值判断
 */
+ (BOOL)isEmpty:(id)sender {
    if (sender == nil || [sender isEqual:@""] || sender == [NSNull null] || [sender isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}
+ (NSString *)compareDate:(NSDate *)date {
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday, *aftertomorrow;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    aftertomorrow = [tomorrow dateByAddingTimeInterval:secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString *afterTomorrowString = [[aftertomorrow description] substringToIndex:10];
    NSString *dateS = [self getDateString:date];
    NSString * dateString = [dateS substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else if([dateString isEqualToString:afterTomorrowString])
    {
        return @"后天";
    }
    else{
        return dateString;
    }
}
+ (NSString*)getDateString:(NSDate *)date {
    NSLog(@"date %@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"datestring %@",dateString);
    return dateString;
}
+ (NSDate *)getTimeDate:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *date  = [dateFormatter dateFromString:timeString];
    return date;
}
+ (NSDate*)getSecondDate:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:SS"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (NSString *)urlPhoto:(NSString*)key {
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@", BaseImageURL,@"1.png?imageView/5/w/320/h/480"];
    } else {
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ( [[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"] )) {
            return key;
        }
        return [NSString stringWithFormat:@"%@%@", BaseImageURL, key];
    }
}

+ (NSString *)urlZoomPhoto:(NSString*)key {
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@", BaseImageURL, @"1.png?imageView/5/w/160/h/160"];
    } else {
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"])) {
            return [NSString stringWithFormat:@"%@?imageView/5/w/160/h/160", key];
        }
        return [NSString stringWithFormat:@"%@%@?imageView/5/w/160/h/160",BaseImageURL,key];
    }
}
+ (NSString *)urlMinePhoto:(NSString*)key {
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@", BaseImageURL, @"1.png?imageView/5/w/480"];
    } else {
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"])) {
            return [NSString stringWithFormat:@"%@?imageView/0/w/480/", key];
        }
        return [NSString stringWithFormat:@"%@%@?imageView/0/w/480",BaseImageURL,key];
    }
}
+ (NSString *)urlWeixinPhoto:(NSString *)key{
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@",BaseImageURL,@"1.png?imageView/3/w/40/h/40"];
    } else {
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"])) {
            return [NSString stringWithFormat:@"%@?imageView/3/w/40/h/40", key];
        }
        return [NSString stringWithFormat:@"%@%@?imageView/3/w/40/h/40",BaseImageURL,key];
    }
}
+ (NSString *)urlCourseListPhoto:(NSString *)key {
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@",BaseImageURL,@"1.png?imageView2/1/w/640/h/320/q/75"];
    } else {
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"])) {
            return [NSString stringWithFormat:@"%@?imageView2/1/w/640/h/320/q/75", key];
        }
        return [NSString stringWithFormat:@"%@%@?imageView2/1/w/640/h/320/q/75",BaseImageURL,key];
    }
}
+ (NSArray *)toArray:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return array;
}
+ (NSString*)urlForVideo:(NSString*)key{
    if ([self isEmpty:key]) {
        return nil;
    } else {
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"])) {
            return [NSString stringWithFormat:@"%@", key];
        }
        return [NSString stringWithFormat:@"%@%@",BaseImageURL,key];
    }
}

@end
