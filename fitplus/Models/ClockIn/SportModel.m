//
//  SportModel.m
//  fitplus
//
//  Created by 天池邵 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SportModel.h"
#import "FetchSportRequest.h"
#import "ClockInRecordRequest.h"

@implementation SportModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id"          : @"goodId",
                                                       @"calorie"     : @"formula",
                                                       @"name"        : @"goodName",
                                                       @"time"        : @"unit"}];
}

+ (void)fetchGoodRank:(RequestResultHandler)handler {
    [[FetchSportRequest new] request:^BOOL(FetchSportRequest *request) {
        request.sportName = nil;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[SportModel new]];
            !handler ?: handler(limitModel.result, msg);
        }
    }];
}

+ (void)fetchGoodByName:(NSString *)name limit:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FetchSportRequest new] request:^BOOL(FetchSportRequest *request) {
        request.sportName = name;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[SportModel new]];
            !handler ?: handler(limitModel, msg);
        }
    }];
}

+ (NSDictionary *)buildRecordWithRecord:(NSArray *)goods calories:(CGFloat)calories tags:(NSArray *)tags content:(NSString *)content {
    NSMutableDictionary *record = [[super buildRecordWithRecord:goods calories:calories tags:tags content:content] mutableCopy];
    NSMutableString *trendsSportId = [NSMutableString string];
    for (SportModel *sport in goods) {
        [trendsSportId appendString:@(sport.goodId).stringValue];
        if (![sport isEqual:goods.lastObject]) {
            [trendsSportId appendString:@";"];
        }
    }
    
    [record setObject:trendsSportId forKey:@"trendsportid"];
    
    [record setObject:@(1) forKey:@"trendsportstype"];
    [record setObject:[goods rb_dictionaryArray] forKey:@"playcard_sport"];
    [record setObject:@(calories) forKey:@"sport_num"];
    
    return record;
}

@end
