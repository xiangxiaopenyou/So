//
//  DrysalteryModel.m
//  fitplus
//
//  Created by xlp on 15/8/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DrysalteryModel.h"
#import "FetchDrysalteryListRequest.h"
#import "LimitResultModel.h"
#import "DrysalteryCollectRequest.h"
#import "DrysalteryCollectionDeleteRequest.h"
#import "DrysalteryDetailRequest.h"
#import "FetchDrysalteryCollectionListRequest.h"
#import "FetchDrysalteryVideoRequest.h"

@implementation DrysalteryModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"dryId"}];
}

+ (void)fetchDryListWith:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FetchDrysalteryListRequest new] request:^BOOL(FetchDrysalteryListRequest *request) {
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"articles" modelClass:[DrysalteryModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}
+ (void)drysalteryDetailWith:(NSString *)articleId handler:(RequestResultHandler)handler {
    [[DrysalteryDetailRequest new] request:^BOOL(DrysalteryDetailRequest *request) {
        request.dryId = articleId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)collectDrysalteryWith:(NSString *)articleId handler:(RequestResultHandler)handler {
    [[DrysalteryCollectRequest new] request:^BOOL(DrysalteryCollectRequest *request) {
        request.articleId = articleId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)cancelCollectDrysalteryWith:(NSString *)articleId handler:(RequestResultHandler)handler {
    [[DrysalteryCollectionDeleteRequest new] request:^BOOL(DrysalteryCollectionDeleteRequest *request) {
        request.articleId = articleId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)drysalteryCollectionListWith:(NSInteger)limit friendId:(NSString *)friendId handler:(RequestResultHandler)handler {
    [[FetchDrysalteryCollectionListRequest new] request:^BOOL(FetchDrysalteryCollectionListRequest *request) {
        request.limit = limit;
        request.friendId = friendId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *tempModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"articles" modelClass:[DrysalteryModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchDryVideoWith:(NSString *)articleId handler:(RequestResultHandler)handler {
    [[FetchDrysalteryVideoRequest new] request:^BOOL(FetchDrysalteryVideoRequest *request) {
        request.articleId = articleId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}

@end
