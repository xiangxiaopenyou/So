//
//  informationImageModel.h
//  fitplus
//
//  Created by 陈 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"
@interface informationImageModel : BaseModel

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *trendpicture;
+ (void)getInfoImageWithFrendid:(NSString *)frendid WithLimit:(NSInteger)limit handler:(RequestResultHandler)handler;
@end
