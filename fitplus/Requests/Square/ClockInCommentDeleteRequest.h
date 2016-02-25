//
//  ClockInCommentDeleteRequest.h
//  fitplus
//
//  Created by xlp on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface ClockInCommentDeleteRequest : RBRequest
@property (copy, nonatomic) NSString *commentId;
@property (assign, nonatomic) NSInteger type;

@end
