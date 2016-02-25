//
//  MessageListModel.m
//  fitplus
//
//  Created by 陈 on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessageUnreadCommentModel.h"
#import "MessageUnreadCommentRequest.h"

@implementation MessageUnreadCommentModel

+ (void)unreadMessage:(RequestResultHandler)handler{
    [[MessageUnreadCommentRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            MessageUnreadCommentModel *messageUnreadCommentModel = [[MessageUnreadCommentModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(messageUnreadCommentModel, nil);
        }
    }];

}

@end
