//
//  DownloadVideo.h
//  test
//
//  Created by xlp on 15/11/3.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface DownloadVideo : NSObject
- (void)downloadFileURL:(NSString *)urlString fileName:(NSString *)fileName tag:(NSInteger)tag;

@end
