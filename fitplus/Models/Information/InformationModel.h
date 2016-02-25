//
//  BackHomeModel.h
//  fitplus
//
//  Created by 陈 on 15/7/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"
#import "ChangeInforModel.h"

@interface InformationModel : BaseModel

@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *attention_num;
@property (nonatomic, strong) NSString *count_day;
@property (nonatomic, strong) NSString *fans_num;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *picture_num;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *sport_num;
@property (nonatomic, strong) NSString *trends_num;
@property (nonatomic, strong) NSString *userid;

+ (void)getInfoMassggeWithFrendid:(NSString *)frendid handler:(RequestResultHandler)handler;
+ (void)fetchMyInfomation:(RequestResultHandler)handler;
+ (void)chageInformationWithImage:(UIImage *)image with:(ChangeInforModel *)changeInforModel handler:(RequestResultHandler)handler;
+ (void)chageInformationWithChageModel:(ChangeInforModel *)changeInforModel handler:(RequestResultHandler)handler;
@end
