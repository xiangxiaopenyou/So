//
//  VideoModel.m
//  fitplus
//
//  Created by xlp on 15/9/30.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "VideoModel.h"
#import "FetchDayVideoRequest.h"

@implementation VideoModel
+ (void)fetchVideoListOfDay:(NSString *)dayid handler:(RequestResultHandler)handler {
    [[FetchDayVideoRequest new] request:^BOOL(FetchDayVideoRequest *request) {
        request.dayId = dayid;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            //NSArray *resultArray = [VideoModel setupWithArray:object[@"list"]];
            NSArray *resultArray = [[VideoModel class] setupWithArray:object[@"data"][@"list"]];
            !handler ?: handler(resultArray, nil);
        }
    }];
}

@end
