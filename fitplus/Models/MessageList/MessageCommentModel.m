//
//  MessageCommentModel.m
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessageCommentModel.h"
#import "MessageCommentRequest.h"
#import "LimitResultModel.h"

@implementation MessageCommentModel

+ (void)MessageCommentWithLimit:(NSInteger)limit handler:(RequestResultHandler)handler{
    [[MessageCommentRequest new] request:^BOOL(MessageCommentRequest *request) {
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        }else{
            LimitResultModel *limitmodel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[MessageCommentModel new]];
            !handler ?: handler(limitmodel, nil);
        }
    }];
}

@end
