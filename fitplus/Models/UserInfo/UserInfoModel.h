//
//  UserInfoModel.h
//  fitplus
//
//  Created by xlp on 15/6/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

+ (void)getWeChatAccessToken:(NSString*)weChatCode handler:(RequestResultHandler)handler;
+ (void)getWeChatUserInfo:(NSString*)openid token:(NSString*)accessToken handler:(RequestResultHandler)handler;
+ (void)weChatLogin:(NSString*)unionid handler:(RequestResultHandler)handler;
+ (void)weChatRegister:(NSDictionary*)dic handler:(RequestResultHandler)handler;
+ (void)finishGuide:(NSDictionary*)dic handler:(RequestResultHandler)handler;
+ (void)fetchRecommendedUsers:(NSInteger)limit handler:(RequestResultHandler)handler;
+ (void)searchFriendsWith:(NSString *)keywords handler:(RequestResultHandler)handler;
+ (void)updateDeviceToken:(NSString *)deviceToken handler:(RequestResultHandler)handler;
+ (void)checkUpdate:(RequestResultHandler)handler;
+ (void)userLogin:(NSString *)nickname password:(NSString *)password handler:(RequestResultHandler)handler;
+ (void)userRegister:(NSString *)nickname password:(NSString *)password handler:(RequestResultHandler)handler;
+ (void)checkAppStore:(RequestResultHandler)handler;
+ (void)addUpUserLiveness:(RequestResultHandler)handler;
+ (void)fetchTags:(RequestResultHandler)handler;
+ (void)submitInformationWith:(NSDictionary *)dic handler:(RequestResultHandler)handler;
+ (void)addRecommendedCourseWith:(NSString *)courseId handler:(RequestResultHandler)handler;
@end
