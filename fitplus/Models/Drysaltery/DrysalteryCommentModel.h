//
//  DrysalteryCommentModel.h
//  fitplus
//
//  Created by xlp on 15/8/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface DrysalteryCommentModel : BaseModel
@property (copy, nonatomic) NSString *articleid;
@property (copy, nonatomic) NSString<Optional> *commentcontent;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *userNickName;
@property (copy, nonatomic) NSString *userPortait;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *recordId;
@property (copy, nonatomic) NSString *createdate;
@property (copy, nonatomic) NSString<Optional> *reply;
@property (copy, nonatomic) NSString<Optional> *commentreplyuserid;
@property (copy, nonatomic) NSString<Optional> *replyUserNickName;
@property (copy, nonatomic) NSString<Optional> *replyUserPortait;
@property (copy, nonatomic) NSString<Optional> *commentid;


+ (void)fetchDrysalteryCommentListWith:(NSString *)articleId limit:(NSInteger)limit handler:(RequestResultHandler)handler;
+ (void)drysalteryCommentWith:(NSString *)articleId content:(NSString *)commentContent handler:(RequestResultHandler)handler;
+ (void)drysalteryReplyWith:(NSString *)articleId content:(NSString *)replyContent commentid:(NSString *)commentId handler:(RequestResultHandler)handler;
+ (void)drysalteryCommentDeleteWith:(NSString *)articleId type:(NSInteger)type handler:(RequestResultHandler)handler;

@end
