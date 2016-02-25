//
//  AddAttentionModel.h
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface AddAttentionModel : BaseModel

+ (void)addAttentionWithfrendid:(NSString *)frendid handler:(RequestResultHandler)handler;
+ (void)cancelAttentionWithFriendId:(NSString *)friendId handler:(RequestResultHandler)handler;

@end
