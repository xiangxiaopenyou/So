//
//  RBCalender.m
//  fitplus
//
//  Created by 天池邵 on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBCalendar.h"
#import "RBGlobal.h"
#import "UICountingLabel.h"

static NSInteger const DaySeconds = 24 * 3600;
static NSInteger const WeekDayLabelTag = 700;

@interface RBCalendar ()
@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) UIView *selectedIndicator;

@property (copy, nonatomic) CalendarSelectedHandler selectedHandler;
@property (copy, nonatomic) CalendarChangeWeekHandler changeWeekHandler;
@end

@implementation RBCalendar

- (void)getSundayAndFriday:(NSDate *)date handler:(void (^)(NSString *, NSString *))handler {
    NSDate *firstDate = [date dateByAddingTimeInterval:-[self indexOfDate:date] * DaySeconds];
    NSDateFormatter *formatter = [[RBGlobal sharedInstance] formatterWithFormatStr:@"YYYY-MM-dd" timeZone:nil];
    !handler ?: handler([formatter stringFromDate:firstDate], [formatter stringFromDate:[firstDate dateByAddingTimeInterval:6 * DaySeconds]]);
}

- (void)setSelectedHandler:(CalendarSelectedHandler)selectedHandler changeWeekHandler:(CalendarChangeWeekHandler)changeWeekHandler {
    _selectedHandler = selectedHandler;
    _changeWeekHandler = changeWeekHandler;
}

- (UIView *)selectedIndicator {
    if (!_selectedIndicator) {
        _selectedIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _selectedIndicator.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.250];
        _selectedIndicator.layer.masksToBounds = YES;
        _selectedIndicator.layer.cornerRadius = 9;
        [self addSubview:_selectedIndicator];
    }
    return _selectedIndicator;
}

- (instancetype)initWithFrame:(CGRect)frame selectedHandler:(CalendarSelectedHandler)selectedHandler changeWeekHandler:(CalendarChangeWeekHandler)changeWeekHandler {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedHandler = selectedHandler;
        _changeWeekHandler = changeWeekHandler;
        _currentDate = [NSDate date];
        [self setupWeekLabels];
        [self setupCurrentWeek];
        [self selectIndex:0 date:_currentDate];
        self.userInteractionEnabled = YES;
        UISwipeGestureRecognizer *rightSwipGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
        rightSwipGR.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipGR];
        
        UISwipeGestureRecognizer *leftSwipGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
        leftSwipGR.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipGR];
    }
    return self;
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        // next week
        NSDate *nextWeekDate = [_currentDate dateByAddingTimeInterval:7 * DaySeconds]; //[NSDate dateWithTimeIntervalSinceNow:7 * 24 * 60 * 60];
        _currentDate = nextWeekDate;
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        // last week
        NSDate *lastWeekDate = [_currentDate dateByAddingTimeInterval:-7 * DaySeconds];
        _currentDate = lastWeekDate;
    }
    [self setupWeekDaysWithDate:_currentDate];
    if ([self isSameDay:_currentDate date:[NSDate date]]) {
        [self selectIndex:0 date:_currentDate];
    } else {
        self.selectedIndicator.hidden = YES;
    }
}

- (NSString *)weekTitleWithIndex:(NSInteger)index {
    NSString *weekTitle;
    switch (index) {
        case 0:
            weekTitle = @"日";
            break;
        case 1:
            weekTitle = @"一";
            break;
        case 2:
            weekTitle = @"二";
            break;
        case 3:
            weekTitle = @"三";
            break;
        case 4:
            weekTitle = @"四";
            break;
        case 5:
            weekTitle = @"五";
            break;
        case 6:
            weekTitle = @"六";
            break;
        default:
            break;
    }
    return weekTitle;
}

- (void)setupWeekLabels {
    CGFloat spacing = (CGRectGetWidth(self.frame) - 20 - 20 * 7) / 6;
    for (int i = 0; i < 7; i ++) {
        NSString *title = [self weekTitleWithIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + (20 + spacing) * i, 5, 20, 20)];
        label.font = [UIFont systemFontOfSize:10];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:1.000 alpha:0.250];
        [self addSubview:label];
    }
}

- (void)setupCurrentWeek {
    [self setupWeekDaysWithDate:[NSDate date]];
}

- (void)setupWeekDaysWithDate:(NSDate *)date {
    NSDate *firstDate = [date dateByAddingTimeInterval:-[self indexOfDate:date] * DaySeconds];
    CGFloat spacing = (CGRectGetWidth(self.frame) - 20 - 20 * 7) / 6;
    for (int i = 0; i < 7; i ++) {
        NSDate *tempDate = [firstDate dateByAddingTimeInterval:i * DaySeconds];
        UICountingLabel *label = (UICountingLabel *)[self viewWithTag:WeekDayLabelTag + i];
        if (!label) {
            label = [[UICountingLabel alloc] initWithFrame:CGRectMake(10 + (20 + spacing) * i, 22, 20, 20)];
            label.font = [UIFont systemFontOfSize:10];
            label.text = @"0";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithWhite:1.000 alpha:0.250];
            [self addSubview:label];
            label.format = @"%.0f";
            label.method = UILabelCountingMethodEaseOut;
            label.tag = WeekDayLabelTag + i;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weekDaysLabelTapHandler:)];
            [label addGestureRecognizer:tapGR];
            label.userInteractionEnabled = YES;
        }
        [label countFrom:label.text.integerValue to:[self dayWithDate:tempDate] withDuration:1];
    }
    NSDateFormatter *formatter = [[RBGlobal sharedInstance] formatterWithFormatStr:@"YYYY-MM-dd" timeZone:nil];
    !_changeWeekHandler ?: _changeWeekHandler([formatter stringFromDate:firstDate], [formatter stringFromDate:[firstDate dateByAddingTimeInterval:6 * DaySeconds]]);
}

- (void)weekDaysLabelTapHandler:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - WeekDayLabelTag;
    [self selectIndex:index date:nil];
}

//- (void)selectDate:(NSDate *)date {
//    NSLog(@"%@", date);
//    !_selectedHandler ?: _selectedHandler(date);
//}

- (void)selectIndex:(NSInteger)index date:(NSDate *)date {
    if (!date) {
        date = [self dateAtIndex:index];
    } else {
        index = [self indexOfDate:date];
    }
    NSInteger tag = index + WeekDayLabelTag;
    UIView *label = [self viewWithTag:tag];
    self.selectedIndicator.center = label.center;
    self.selectedIndicator.hidden = NO;
    !_selectedHandler ?: _selectedHandler(index, date);
}

- (NSDateComponents *)componentsWithDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

- (NSInteger)indexOfDate:(NSDate *)date {
    NSDateComponents *comps = [self componentsWithDate:date];
    return comps.weekday - 1;
}

- (NSInteger)dayWithDate:(NSDate *)date {
    NSDateComponents *comps = [self componentsWithDate:date];
    return comps.day;
}

- (NSInteger)mondayInWeekByDate:(NSDate *)date {
    NSDateComponents *comps = [self componentsWithDate:date];
    return comps.day - comps.weekday + 1;
}

- (NSDate *)dateAtIndex:(NSInteger)index {
    NSDateComponents *comps = [self componentsWithDate:_currentDate];
    NSInteger weekDay = comps.weekday;
    
    NSDate *date = [_currentDate dateByAddingTimeInterval:(index - weekDay + 1) * DaySeconds];
    return date;
}

- (BOOL)isSameDay:(NSDate *)date1 date:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsForFirstDate = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date1];
    NSDateComponents *componentsForSecondDate = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date2];
    
    return componentsForFirstDate.day == componentsForSecondDate.day;
}


@end
