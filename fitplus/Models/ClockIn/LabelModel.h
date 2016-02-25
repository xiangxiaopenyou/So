//
//  LabelModel.h
//  fitplus
//
//  Created by xlp on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface LabelModel : BaseModel
@property (copy, nonatomic) NSString *labelId;
@property (copy, nonatomic) NSString *labelName;
@property (copy, nonatomic) NSNumber *type;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSNumber *num;

+ (void)fetchLabelListWith:(NSString *)like limit:(NSInteger)limit handler:(RequestResultHandler)handler;

@end
