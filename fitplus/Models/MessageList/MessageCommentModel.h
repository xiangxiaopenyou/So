//
//  MessageCommentModel.h
//  fitplus
//
//  Created by 陈 on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface MessageCommentModel : BaseModel
@property (nonatomic, strong) NSString *cpartakcontent;
@property (nonatomic, strong) NSString *isread;
@property (nonatomic, strong) NSString *trendid;
@property (nonatomic, strong) NSString *trendphoto;
@property (nonatomic, strong) NSString *trendscommentcontent;
@property (nonatomic, strong) NSString *trendscommenttime;
@property (nonatomic, strong) NSString *trendstype;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userportrait;

+ (void)MessageCommentWithLimit:(NSInteger)limit handler:(RequestResultHandler)handler;

@end
