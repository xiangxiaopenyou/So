//
//  PhotoTagModel.h
//  fitplus
//
//  Created by 天池邵 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@protocol PhotoTagModel
@end

@interface PhotoTagModel : BaseModel
@property (assign, nonatomic) NSInteger tagId;
@property (copy, nonatomic) NSString *tagName;
@property (strong, nonatomic) NSNumber<Optional> *x;
@property (strong, nonatomic) NSNumber<Optional> *y;
@end
