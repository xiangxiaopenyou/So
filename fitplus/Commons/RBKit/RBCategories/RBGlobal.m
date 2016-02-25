//
//  RBGlobal.m
//  RainbowKit
//
//  Created by 天池邵 on 15/3/30.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "RBGlobal.h"

@interface RBGlobal ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation RBGlobal
+ (instancetype)sharedInstance {
    static RBGlobal *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return self;
}

static NSString *const TimeZone_Asia = @"Asia/Shanghai";
- (NSDateFormatter *)formatterWithFormatStr:(NSString *)formatStr timeZone:(NSString *)timeZone {
    [_dateFormatter setDateFormat:formatStr];
    if (!timeZone || [timeZone isEqualToString:@""]) {
        timeZone = TimeZone_Asia;
    }
    [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    return _dateFormatter;
}

@end
