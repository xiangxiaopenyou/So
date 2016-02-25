//
//  FansDataModel.h
//  fitplus
//
//  Created by 陈 on 15/7/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface FansDataModel : BaseModel
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *portrait;
+ (void)getFansDataWithFrendid:(NSString *)frendid WithLimit:(NSInteger)limit handler:(RequestResultHandler)handler;

@end
