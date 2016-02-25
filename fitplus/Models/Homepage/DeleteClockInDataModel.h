//
//  DeleteClockInDataModel.h
//  fitplus
//
//  Created by 陈 on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface DeleteClockInDataModel : BaseModel

+ (void)deleteClockInWithTrendid:(NSString *)trendid handler:(RequestResultHandler)handler;

@end
