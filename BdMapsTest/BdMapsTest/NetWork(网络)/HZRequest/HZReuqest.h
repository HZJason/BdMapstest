//
//  HZReuqest.h
//  DuDuCar
//
//  Created by 黄泽 on 2017/5/3.
//  Copyright © 2017年 黄泽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 请求成功的block
 @param response 响应体数据
 */
typedef void(^HZReuqestSuccess)(id response);
/**
 请求失败的block
 
 */
typedef void(^HZReuqestFailure)(NSError *error);

/**
 图片上传的进度
 */
typedef void (^HZProgress)(NSProgress *progress);

@interface HZReuqest : NSObject

/** 带参数的Post请求*/
+ (NSURLSessionTask *)requestWithURL:(NSString *)URLFace parameters:(NSDictionary *)parameter success:(HZReuqestSuccess)success failure:(HZReuqestFailure)failure;


@end
