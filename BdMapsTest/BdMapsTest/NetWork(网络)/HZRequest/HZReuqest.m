//
//  HZReuqest.m
//  DuDuCar
//
//  Created by 黄泽 on 2017/5/3.
//  Copyright © 2017年 黄泽. All rights reserved.
//

#import "HZReuqest.h"
#import "PPNetworkHelper.h"
@implementation HZReuqest

+ (NSURLSessionTask *)requestWithURL:(NSString *)URLFace parameters:(NSDictionary *)parameter success:(HZReuqestSuccess)success failure:(HZReuqestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    [PPNetworkHelper setValue:@"9" forHTTPHeaderField:@"fromType"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",Environment_Domain,URLFace];

    // 发起请求
    return [PPNetworkHelper POST:URL parameters:parameter success:^(id responseObject) {
        
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        success(responseObject);
        
        
        
    } failure:^(NSError *error) {
        // 同上
        failure(error);
    }];
}

+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URLFace parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(HZProgress)progress success:(HZReuqestSuccess)success failure:(HZReuqestFailure)failure
{
    NSString *URL = [NSString stringWithFormat:@"%@%@",Environment_Domain,URLFace];

    return [PPNetworkHelper uploadImagesWithURL:URL parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progress:^(NSProgress *_Nonnull uploadProgress) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
       
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
