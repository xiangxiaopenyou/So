//
//  QNImageUploadRequest.m
//  fitplus
//
//  Created by 天池邵 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "QNImageUploadRequest.h"
#import <QiniuSDK.h>
#import "UIImage+ResizeMagick.h"
#import "NSArray+RBAddition.h"
#import <AssetsLibrary/AssetsLibrary.h>
@implementation QNImageUploadRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    
    if (!_images || _images.count == 0) {
        !resultHandler ?: resultHandler(nil, @"dev error: image can not be empty");
        return;
    }
    
    NSDictionary *qnParam = @{};
    [[RequestManager sharedInstance] POST:@"QiNiuToken/stk" parameters:qnParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1000) {
            NSString *token = responseObject[@"data"];
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            NSMutableArray *keys = [NSMutableArray array];
            for (UIImage *image in _images) {
                NSData *data = [image rmk_resizedAndReturnData];
                NSString *fileName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
                [upManager putData:data key:fileName token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              [keys addObject:key];
                              if (keys.count == _images.count) {
                                  !resultHandler ?: resultHandler(keys, nil);
                              }
                          } option:nil];
            }
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, [self handlerError:error]);
    }];
}
@end
