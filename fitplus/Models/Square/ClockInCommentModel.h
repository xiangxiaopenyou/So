//
//  ClockInCommentModel.h
//  fitplus
//
//  Created by xlp on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface ClockInCommentModel : BaseModel
@property (copy, nonatomic) NSString *commentid;
@property (assign, nonatomic) NSInteger commenttype;
@property (copy, nonatomic) NSString *firstUserId;
@property (copy, nonatomic) NSString *firstUserNickname;
@property (copy, nonatomic) NSString *secondUserId;
@property (copy, nonatomic) NSString *secondUserNickname;
@property (copy, nonatomic) NSString *commentContent;
@property (copy, nonatomic) NSString *replyContent;
@property (copy, nonatomic) NSString *firstUserHead;
@property (copy, nonatomic) NSString *created_time;

+ (void)fetchClockInComments:(NSString *)trendid limit:(NSInteger)limit handler:(RequestResultHandler)handler;
+ (void)clockInComment:(NSString *)trendId content:(NSString *)commentContent handler:(RequestResultHandler)handler;
+ (void)clockInReply:(NSString *)trendId commentid:(NSString *)commentId content:(NSString *)replyContent handler:(RequestResultHandler)handler;
+ (void)clockInCommentDelete:(NSString *)commentId type:(NSInteger)type handler:(RequestResultHandler)handler;

@end
