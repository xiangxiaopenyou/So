//
//  FetchMoreCourseRequest.h
//  fitplus
//
//  Created by xlp on 15/9/22.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchMoreCourseRequest : RBRequest
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger courseDifficulty;
@property (nonatomic, assign) NSInteger courseModel;
@property (nonatomic, assign) NSString *courseSite;

@end
