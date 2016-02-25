//
//  CalorieDataModel.m
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CalorieDataModel.h"

#import "UploadStepDataRequest.h"
#import "FetchCalorieDataRequest.h"

@implementation CalorieDataModel
+ (void)fetchCalorieData:(NSInteger)friendid day:(NSString *)day handler:(RequestResultHandler)handler {
    [[FetchCalorieDataRequest new] request:^BOOL(FetchCalorieDataRequest *request) {
        request.friendId = friendid;
        request.day = day;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(object, msg);
        } else {
            !handler ?: handler([[CalorieDataModel alloc] initWithDictionary:object error:nil], nil);
        }
    }];
}

+ (void)uploadStepDatas:(NSArray *)stepDatas handler:(RequestResultHandler)handler {
    NSData *data = [NSJSONSerialization dataWithJSONObject:stepDatas options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[UploadStepDataRequest new] request:^BOOL(UploadStepDataRequest *request) {
        request.json = json;
        return YES;
    } result:handler];
}

@end
