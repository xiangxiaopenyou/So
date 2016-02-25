//
//  AddAttentionModel.m
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AddAttentionModel.h"
#import "AddAttentionRequest.h"
#import "CancelAttentionRequest.h"
@implementation AddAttentionModel

+ (void)addAttentionWithfrendid:(NSString *)frendid handler:(RequestResultHandler)handler{
    [[AddAttentionRequest new] request:^BOOL(AddAttentionRequest *request) {
        request.friendid = frendid;
        return YES;
    } result:^(id object, NSString *msg) {
            if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];

}
+ (void)cancelAttentionWithFriendId:(NSString *)friendId handler:(RequestResultHandler)handler {
    [[CancelAttentionRequest new] request:^BOOL(CancelAttentionRequest *request) {
        request.friendId = friendId;
        return YES;
    } result:^(NSArray* object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}

@end
