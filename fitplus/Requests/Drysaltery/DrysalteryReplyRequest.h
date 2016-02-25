//
//  DrysalteryReplyRequest.h
//  fitplus
//
//  Created by xlp on 15/8/11.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface DrysalteryReplyRequest : RBRequest
@property (copy, nonatomic) NSString *articleId;
@property (copy, nonatomic) NSString *commentId;
@property (copy, nonatomic) NSString *replyContent;

@end
