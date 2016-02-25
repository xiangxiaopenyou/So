//
//  DrysalteryCommentListRequest.h
//  fitplus
//
//  Created by xlp on 15/8/11.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface DrysalteryCommentListRequest : RBRequest
@property (copy, nonatomic) NSString *articleId;
@property (assign, nonatomic) NSInteger limit;

@end
