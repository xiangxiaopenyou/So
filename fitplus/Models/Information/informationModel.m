//
//  BackHomeModel.m
//  fitplus
//
//  Created by 陈 on 15/7/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "InformationModel.h"
#import "InformationRequest.h"
#import "GetOwnInfomationRequest.h"
#import "ChangeInformationRequest.h"
#import "ChangeInforModel.h"
#import "ChangeInforNoImageRequest.h"

@implementation InformationModel

+ (void)getInfoMassggeWithFrendid:(NSString *)frendid handler:(RequestResultHandler)handler{
    [[InformationRequest new] request:^BOOL(InformationRequest* request) {
        request.frendid = frendid;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        }else{
        InformationModel *model = [[InformationModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(model, nil);
    }
    }];

}
+ (void)fetchMyInfomation:(RequestResultHandler)handler {
    [[GetOwnInfomationRequest new] request:^BOOL(GetOwnInfomationRequest *request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)chageInformationWithImage:(UIImage *)image with:(ChangeInforModel *)changeInforModel handler:(RequestResultHandler)handler{
    [[ChangeInformationRequest new] request:^BOOL(ChangeInformationRequest *request) {
        request.duration = changeInforModel.duration ;
        request.height = changeInforModel.height;
        request.introduce = changeInforModel.introduce;
        request.nickname = changeInforModel.nickname;
        request.portrait = image;
        request.sex = changeInforModel.sex;
        request.weight = changeInforModel.weight;
        request.weightT= changeInforModel.weightT;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }

    }];
}

+ (void)chageInformationWithChageModel:(ChangeInforModel *)changeInforModel handler:(RequestResultHandler)handler{
    [[ChangeInforNoImageRequest new] request:^BOOL(ChangeInforNoImageRequest *request) {
        request.duration = changeInforModel.duration;
        request.height = changeInforModel.height;
        request.introduce = changeInforModel.introduce;
        request.nickname = changeInforModel.nickname;
        request.portrait = changeInforModel.portrait;
        request.sex = changeInforModel.sex;
        request.weight = changeInforModel.weight;
        request.weightT= changeInforModel.weightT;
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
