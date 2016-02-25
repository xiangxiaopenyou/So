//
//  ChangeInforModel.m
//  fitplus
//
//  Created by 陈 on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChangeInforModel.h"
#import "GetOwnInfomationRequest.h"
@implementation ChangeInforModel

+ (void)fetchMyInfomation:(RequestResultHandler)handler {
    [[GetOwnInfomationRequest new] request:^BOOL(GetOwnInfomationRequest *request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            ChangeInforModel *changeinforModel = [[ChangeInforModel alloc] initWithDictionary:object error:nil];
            
            !handler ?: handler(changeinforModel, nil);
        }
    }];
}
@end
