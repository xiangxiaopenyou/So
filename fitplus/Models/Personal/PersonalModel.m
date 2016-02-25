//
//  PersonalModel.m
//  fitplus
//
//  Created by xlp on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonalModel.h"
#import "GetVerificationCodeRequest.h"
#import "BindingMobileRequest.h"
#import "HelpAndFeedbackRequest.h"
#import "FetchMyHobbiesRequest.h"
#import "ChooseMyHobbiesRequest.h"

@implementation PersonalModel
+ (void)getVerificationCodeWith:(NSString *)phoneNumber handler:(RequestResultHandler)handler {
    [[GetVerificationCodeRequest new] request:^BOOL(GetVerificationCodeRequest *request) {
        request.phoneNumber = phoneNumber;
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)bindingMobileWith:(NSString *)phoneNumber code:(NSString *)code handler:(RequestResultHandler)handler {
    [[BindingMobileRequest new] request:^BOOL(BindingMobileRequest *request) {
        request.phoneNumber = phoneNumber;
        request.code = code;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)helpAndFeedbackWith:(NSString *)content handler:(RequestResultHandler)handler {
    [[HelpAndFeedbackRequest new] request:^BOOL(HelpAndFeedbackRequest *request) {
        request.content = content;
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)fetchMyHobbies:(RequestResultHandler)handler {
    [[FetchMyHobbiesRequest new] request:^BOOL(FetchMyHobbiesRequest *request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)chooseMyHobbiesWith:(NSString *)hobbyId handler:(RequestResultHandler)handler {
    [[ChooseMyHobbiesRequest new] request:^BOOL(ChooseMyHobbiesRequest *request) {
        request.partsId = hobbyId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}

@end
