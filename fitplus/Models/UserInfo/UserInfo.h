//
//  UserInfo.h
//  fitplus
//
//  Created by xlp on 15/6/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfo : BaseModel
@property (nonatomic, copy) NSString *userid;
//@property (nonatomic, copy) NSString *usertoken;
@property (nonatomic, copy) NSString *headportrait;
@property (nonatomic, copy) NSString *nickname;
@property (assign, nonatomic) NSInteger isAttention;
@property (copy, nonatomic) NSString *introduce;
//@property (nonatomic, copy) NSString *height;
//@property (nonatomic, copy) NSString *weightT;
//@property (nonatomic, copy) NSString *weight;
//@property (nonatomic, copy) NSString *sex;
//@property (nonatomic, copy) NSString *parts;
//@property (nonatomic, copy) NSString *duration;
//@property (nonatomic, copy) NSString *birthday;
+ (BOOL)userHaveLogin;
@end
