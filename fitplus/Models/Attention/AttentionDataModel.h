//
//  AttentionDataModel.h
//  fitplus
//
//  Created by 陈 on 15/7/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface AttentionDataModel : BaseModel
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *portrait;

+ (void)getAttentionDataWithFrendid:(NSString *)frendid WithLimit:(NSInteger)limit handler:(RequestResultHandler)handler;

@end
