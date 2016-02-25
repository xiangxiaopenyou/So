//
//  ClockInDetailModel.m
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInDetailModel.h"
#import "FetchClockInDetailRequest.h"
#import "FriendsClockInRequest.h"
#import "LimitResultModel.h"

@implementation ClockInDetailModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"portrait" : @"headPortraintString",
                                                       @"trendcontent" : @"clockinContent",
                                                       @"trendpicture" : @"clockinPicture",
                                                       @"trendaddress" : @"clockinAddress",
                                                       @"food_num" : @"foodEnergy",
                                                       @"playcard_food" : @"foodName",
                                                       @"sport_num" : @"sportsEnergy",
                                                       @"playcard_sport" : @"sportsName",
                                                       @"palycard_tag" : @"clockinTag",
                                                       @"isfavorite" : @"isfavorite",
                                                       @"trendsportstype" : @"clockinType",
                                                       @"trendscomment_num" : @"commentNumber",
                                                       @"trendsfavorite_num" : @"likeNumber"
                                                       }];
}

+ (void)fetchClockInDetail:(NSString *)trendid handler:(RequestResultHandler)handler {
    [[FetchClockInDetailRequest new] request:^BOOL(FetchClockInDetailRequest *request) {
        request.trendid = trendid;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object[@"data"], nil);
        }
    }];
}
+ (void)fetchFriendsClockIn:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FriendsClockInRequest new] request:^BOOL(FriendsClockInRequest *request) {
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[ClockInDetailModel new]];
            !handler ?: handler(limitModel, msg);
        }
    }];
}

@end
