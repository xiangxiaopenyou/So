//
//  MessageListModel.h
//  fitplus
//
//  Created by 陈 on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface MessageUnreadCommentModel : BaseModel
@property (nonatomic, strong) NSString *comment_num;
@property (nonatomic, strong) NSString *favorite_num;

+ (void)unreadMessage:(RequestResultHandler)handler;

@end
