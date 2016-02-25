//
//  DrysalteryCommentDeleteRequest.h
//  fitplus
//
//  Created by xlp on 15/8/11.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface DrysalteryCommentDeleteRequest : RBRequest
@property (copy, nonatomic) NSString *commentId;
@property (assign, nonatomic) NSInteger type;

@end
