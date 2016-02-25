//
//  FoodModel.m
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FoodModel.h"
#import "ClockInRecordRequest.h"
#import "NSArray+RBAddition.h"
#import "FetchFoodsReqeust.h"
#import "LimitResultModel.h"
#import "PhotoTagModel.h"

@implementation FoodModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id"          : @"goodId",
                                                       @"calorie"     : @"formula",
                                                       @"convert"     : @"transformUnit",
                                                       @"convert_num" : @"transformFormula",
                                                       @"name"        : @"goodName"}];
}

+ (void)fetchGoodRank:(RequestResultHandler)handler {
    [[FetchFoodsReqeust new] request:^BOOL(FetchFoodsReqeust *request) {
        request.foodName = nil;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[FoodModel new]];
            !handler ?: handler(limitModel.result, msg);
        }
    }];
}

+ (void)fetchGoodByName:(NSString *)name limit:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FetchFoodsReqeust new] request:^BOOL(FetchFoodsReqeust *request) {
        request.foodName = name;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[FoodModel new]];
            !handler ?: handler(limitModel, msg);
        }
    }];
}

+ (NSDictionary *)buildRecordWithRecord:(NSArray *)goods calories:(CGFloat)calories tags:(NSArray *)tags content:(NSString *)content {
    NSMutableDictionary *record = [[super buildRecordWithRecord:goods calories:calories tags:tags content:content] mutableCopy];
    NSMutableString *trendsFoodId = [NSMutableString string];
    for (FoodModel *food in goods) {
        [trendsFoodId appendString:@(food.goodId).stringValue];
        if (![food isEqual:goods.lastObject]) {
            [trendsFoodId appendString:@";"];
        }
    }
    
    [record setObject:trendsFoodId forKey:@"trendsfoodid"];
    
    [record setObject:@(2) forKey:@"trendsportstype"];
    [record setObject:[goods rb_dictionaryArray] forKey:@"playcard_food"];
    [record setObject:@(calories) forKey:@"food_num"];
    return record;
}
@end
