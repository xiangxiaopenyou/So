//
//  UserInfoModel.m
//  fitplus
//
//  Created by xlp on 15/6/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UserInfoModel.h"
#import "WechatLoginRequest.h"
#import "WeChatAccessRequest.h"
#import "WeChatUserInfoRequest.h"
#import "WeChatRegisterRequest.h"
#import "GuideRequest.h"
#import "FetchRecommendedUsersRequest.h"
#import "LimitResultModel.h"
#import "UserInfo.h"
#import "UpdateDeviceTokenRequest.h"
#import "SearchFriendsRequest.h"
#import "CheckUpdateRequest.h"
#import "UserLoginRequest.h"
#import "UserRegisterRequest.h"
#import "CheckAppStoreRequest.h"
#import "UserLivenessRequest.h"
#import "FetchTagsRequest.h"
#import "SubmitInfomationRequest.h"
#import "CourseModel.h"
#import "AddRecommendedCourseRequest.h"
@implementation UserInfoModel

+ (void)getWeChatAccessToken:(NSString *)weChatCode handler:(RequestResultHandler)handler {
    [[WeChatAccessRequest new] request:^BOOL(WeChatAccessRequest *request) {
        request.code = weChatCode;
        return YES;
    } result:handler];
}
+ (void)getWeChatUserInfo:(NSString *)openid token:(NSString *)accessToken handler:(RequestResultHandler)handler {
    [[WeChatUserInfoRequest new] request:^BOOL(WeChatUserInfoRequest *request) {
        request.openid = openid;
        request.accessToken = accessToken;
        return YES;
    } result:handler];
}
+ (void)weChatLogin:(NSString *)unionid handler:(RequestResultHandler)handler {
    [[WechatLoginRequest new] request:^BOOL(WechatLoginRequest *request) {
        request.openid = unionid;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)weChatRegister:(NSDictionary *)dic handler:(RequestResultHandler)handler {
    [[WeChatRegisterRequest new] request:^BOOL(WeChatRegisterRequest *request) {
        request.openid = dic[@"unionid"];
        request.nickname = dic[@"nickname"];
        request.sex = dic[@"sex"];
        request.systemType = @"ios";
        request.headportrait = dic[@"headportrait"];
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)finishGuide:(NSDictionary *)dic handler:(RequestResultHandler)handler {
    [[GuideRequest new] request:^BOOL(GuideRequest *request) {
        request.sex = dic[@"sex"];
        request.age = dic[@"age"];
        request.weight = dic[@"weight"];
        request.height = dic[@"height"];
//        request.targetWeight = dic[@"targetWeight"];
//        request.duration = dic[@"duration"];
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)fetchRecommendedUsers:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FetchRecommendedUsersRequest new] request:^BOOL(FetchRecommendedUsersRequest *request) {
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[UserInfo new]];
            !handler ?: handler(limitModel, nil);
        }
    }];
}
+ (void)searchFriendsWith:(NSString *)keywords handler:(RequestResultHandler)handler {
    [[SearchFriendsRequest new] request:^BOOL(SearchFriendsRequest *request) {
        request.keywords = keywords;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
//            LimitResultModel *limitModel = [[LimitResultModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[UserInfo new]];
            NSMutableArray *tempArray = [object[@"data"] mutableCopy];
            id reslut = [[[UserInfo new] class] setupWithArray:tempArray];
            !handler ?: handler(reslut, nil);
        }
    }];
}

+ (void)updateDeviceToken:(NSString *)deviceToken handler:(RequestResultHandler)handler {
    [[UpdateDeviceTokenRequest new] request:^BOOL(UpdateDeviceTokenRequest *request) {
        request.deviceToken = deviceToken;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)checkUpdate:(RequestResultHandler)handler {
    [[CheckUpdateRequest new] request:^BOOL(CheckUpdateRequest *request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)userLogin:(NSString *)nickname password:(NSString *)password handler:(RequestResultHandler)handler {
    [[UserLoginRequest new] request:^BOOL(UserLoginRequest *request) {
        request.nickname = nickname;
        request.password = password;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)userRegister:(NSString *)nickname password:(NSString *)password handler:(RequestResultHandler)handler {
    [[UserRegisterRequest new] request:^BOOL(UserRegisterRequest *request) {
        request.nickname = nickname;
        request.password = password;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)checkAppStore:(RequestResultHandler)handler {
    [[CheckAppStoreRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)addUpUserLiveness:(RequestResultHandler)handler {
    [[UserLivenessRequest new] request:^BOOL(id request) {
        return YES;
    } result:handler];
}
+ (void)fetchTags:(RequestResultHandler)handler {
    [[FetchTagsRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)submitInformationWith:(NSDictionary *)dic handler:(RequestResultHandler)handler {
    [[SubmitInfomationRequest new] request:^BOOL(SubmitInfomationRequest *request) {
        request.dictionary = dic;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            LimitResultModel *tempModel = [[LimitResultModel alloc] initWithNewResult:object modelKey:@"list" modelClass:[CourseModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)addRecommendedCourseWith:(NSString *)courseId handler:(RequestResultHandler)handler {
    [[AddRecommendedCourseRequest new] request:^BOOL(AddRecommendedCourseRequest *request) {
        request.courseId = courseId;
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
