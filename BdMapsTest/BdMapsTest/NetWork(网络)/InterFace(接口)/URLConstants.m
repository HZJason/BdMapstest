//
//  URLConstants.m
//  BasicFramework
//
//  Created by Rainy on 2016/11/16.
//  Copyright © 2016年 Rainy. All rights reserved.
//
#import <Foundation/Foundation.h>
#pragma mark -  * * * * * * * * * * * * * * 域名切换 * * * * * * * * * * * * * *

#if ENVIRONMENT == 0
/**
 *  @开发环境
 */
NSString *const Environment_Domain = @"http://117.156.24.222";

#elif ENVIRONMENT ==1
/**
 *  @param 测试环境
 */
NSString *const Environment_Domain = @"_API_Domain_测试环境";

#elif ENVIRONMENT ==2
/**
 *  @param 正式环境
 */
NSString *const Environment_Domain = @"_API_Domain_正式环境";

#else

NSString *const Environment_Domain = @"'ENVIRONMENT'-(0/1/2)";

#endif /* HTTPURLDefine_h */


#pragma mark -  * * * * * * * * * * * * * * URLs * * * * * * * * * * * * * *

NSString * const Login_URL = @"/userAction/userLogin.do";



