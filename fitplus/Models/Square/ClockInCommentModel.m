//
//  ClockInCommentModel.m
//  fitplus
//
//  Created by xlp on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInCommentModel.h"
#import "ClockInCommentsListRequest.h"
#import "LimitResultModel.h"
#import "ClockInCommentRequest.h"
#import "ClockInReplyRequest.h"
#import "ClockInCommentDeleteRequest.h"

@implementation ClockInCommentModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"commentid",
                                                       @"type" : @"commenttype",
                                                       @"userid" : @"firstUserId",
                                                       @"usernickname" : @"firstUserNickname",
                                                       @"userportrait" : @"firstUserHead",
                                                       @"commentreplyuserid" : @"secondUserId",
                                                       @"commentreplyusernickname" : @"secondUserNickname",
                                                       @"commentcontent" : @"commentContent",
                                                       @"reply" : @"replyContent"
                                                       }];
}

+ (void)fetchClockInComments:(NSString *)trendid limit:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[ClockInCommentsListRequest new] request:^BOOL(ClockInCommentsListRequest *request) {
        request.trendid = trendid;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[ClockInCommentModel new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}
+ (void)clockInComment:(NSString *)trendId content:(NSString *)commentContent handler:(RequestResultHandler)handler {
    [[ClockInCommentRequest new] request:^BOOL(ClockInCommentRequest *request) {
        request.trendId = trendId;
        request.commentContent = commentContent;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)clockInReply:(NSString *)trendId commentid:(NSString *)commentId content:(NSString *)replyContent handler:(RequestResultHandler)handler {
    [[ClockInReplyRequest new] request:^BOOL(ClockInReplyRequest *request) {
        request.trendId = trendId;
        request.commentId = commentId;
        request.replyContent = replyContent;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)clockInCommentDelete:(NSString *)commentId type:(NSInteger)type handler:(RequestResultHandler)handler {
    [[ClockInCommentDeleteRequest new] request:^BOOL(ClockInCommentDeleteRequest *request) {
        request.commentId = commentId;
        request.type = type;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}

@end
