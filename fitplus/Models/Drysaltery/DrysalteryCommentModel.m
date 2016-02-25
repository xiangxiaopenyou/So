//
//  DrysalteryCommentModel.m
//  fitplus
//
//  Created by xlp on 15/8/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DrysalteryCommentModel.h"
#import "DrysalteryCommentRequest.h"
#import "DrysalteryReplyRequest.h"
#import "DrysalteryCommentListRequest.h"
#import "LimitResultModel.h"
#import "DrysalteryCommentDeleteRequest.h"

@implementation DrysalteryCommentModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"recordId"}];
}
+ (void)fetchDrysalteryCommentListWith:(NSString *)articleId limit:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[DrysalteryCommentListRequest new] request:^BOOL(DrysalteryCommentListRequest *request) {
        request.articleId = articleId;
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *tempModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"articles" modelClass:[DrysalteryCommentModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)drysalteryCommentWith:(NSString *)articleId content:(NSString *)commentContent handler:(RequestResultHandler)handler {
    [[DrysalteryCommentRequest new] request:^BOOL(DrysalteryCommentRequest *request) {
        request.articleId = articleId;
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
+ (void)drysalteryReplyWith:(NSString *)articleId content:(NSString *)replyContent commentid:(NSString *)commentId handler:(RequestResultHandler)handler {
    [[DrysalteryReplyRequest new] request:^BOOL(DrysalteryReplyRequest *request) {
        request.articleId = articleId;
        request.replyContent = replyContent;
        request.commentId = commentId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)drysalteryCommentDeleteWith:(NSString *)articleId type:(NSInteger)type handler:(RequestResultHandler)handler {
    [[DrysalteryCommentDeleteRequest new] request:^BOOL(DrysalteryCommentDeleteRequest *request) {
        request.type = type;
        request.commentId = articleId;
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
