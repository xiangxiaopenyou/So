//
//  PersonalModel.h
//  fitplus
//
//  Created by xlp on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface PersonalModel : BaseModel

+ (void)getVerificationCodeWith:(NSString *)phoneNumber handler:(RequestResultHandler)handler;
+ (void)bindingMobileWith:(NSString *)phoneNumber code:(NSString *)code handler:(RequestResultHandler)handler;
+ (void)helpAndFeedbackWith:(NSString *)content handler:(RequestResultHandler)handler;
+ (void)fetchMyHobbies:(RequestResultHandler)handler;
+ (void)chooseMyHobbiesWith:(NSString *)hobbyId handler:(RequestResultHandler)handler;

@end
