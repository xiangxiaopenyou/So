//
//  Util.h
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+ (BOOL)isEmpty:(id)sender;
+ (NSString*)getDateString:(NSDate *)date;
+ (NSString *)compareDate:(NSDate *)date;
+ (NSDate *)getTimeDate:(NSString *)timeString;
+ (NSDate*)getSecondDate:(NSString *)dateString;

+ (NSString *)urlPhoto:(NSString*)key;
+ (NSString *)urlZoomPhoto:(NSString*)key;
+ (NSString *)urlMinePhoto:(NSString*)key;
+ (NSString *)urlWeixinPhoto:(NSString *)key;
+ (NSString *)urlCourseListPhoto:(NSString *)key;

+ (NSArray *)toArray:(NSString *)jsonString;
+ (NSString*)urlForVideo:(NSString*)key;


@end
