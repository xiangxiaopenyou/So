//
//  RBCalender.h
//  fitplus
//
//  Created by 天池邵 on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CalendarSelectedHandler)(NSInteger index, NSDate *date);
typedef void(^CalendarChangeWeekHandler)(NSString *sunday, NSString *friday);

@interface RBCalendar : UIView
- (instancetype)initWithFrame:(CGRect)frame selectedHandler:(CalendarSelectedHandler)selectedHandler changeWeekHandler:(CalendarChangeWeekHandler)changeWeekHandler;

- (void)getSundayAndFriday:(NSDate *)date handler:(void(^)(NSString *sunday, NSString *friday))handler;
@end
