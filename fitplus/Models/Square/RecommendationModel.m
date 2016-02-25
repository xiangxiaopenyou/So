//
//  RecommendationModel.m
//  fitplus
//
//  Created by xlp on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RecommendationModel.h"
#import "RecommendationRequst.h"
#import "TopicListRequest.h"
#import "FetchActivityRequest.h"
#import "ClockInLikeRequest.h"
#import "ClocInDislikeRequest.h"
#import "ClockInReportRequest.h"
#import "MoreClockInOfTopicRequest.h"
#import "LimitResultModel.h"
#import "ClockInDetailModel.h"
#import "TodayRecommendationRequest.h"

@implementation RecommendationModel

+ (void)fetchRecommendationContent:(RequestResultHandler)handler {
    [[RecommendationRequst new] request:^BOOL(RecommendationRequst *request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)fetchTopicList:(RequestResultHandler)handler {
    [[TopicListRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)fetchActivities:(RequestResultHandler)handler {
    [[FetchActivityRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)clockInLike:(NSString *)trendId handler:(RequestResultHandler)handler {
    [[ClockInLikeRequest new] request:^BOOL(ClockInLikeRequest *request) {
        request.trendId = trendId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)clockInDislike:(NSString *)trendId handler:(RequestResultHandler)handler {
    [[ClocInDislikeRequest new] request:^BOOL(ClocInDislikeRequest *request) {
        request.trendId = trendId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)clockinReport:(NSString *)reportId type:(NSString *)reportType handler:(RequestResultHandler)handler {
    [[ClockInReportRequest new] request:^BOOL(ClockInReportRequest *request) {
        request.reportId = reportId;
        request.reportType = reportType;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)fetchMoreClockInOfTopic:(NSString *)topicId handler:(RequestResultHandler)handler {
    [[MoreClockInOfTopicRequest new] request:^BOOL(MoreClockInOfTopicRequest *request) {
        request.topicId = topicId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[ClockInDetailModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}
+ (void)fetchTodayRecommendation:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[TodayRecommendationRequest new] request:^BOOL(TodayRecommendationRequest *request) {
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[ClockInDetailModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}

@end
