//
//  MyModel.h
//  DuDuCar
//
//  Created by 黄泽 on 2017/5/13.
//  Copyright © 2017年 黄泽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject

//经纬度
@property (nonatomic,copy) NSString * longitude;
@property (nonatomic,copy) NSString * latitude;
///详细地址
@property (nonatomic,copy) NSString * address;
//停车场名称
@property (nonatomic,copy) NSString *name;
//停车场id
@property (nonatomic,copy) NSString * ID;
//收费规则
@property (nonatomic,copy) NSString * typenamed;
//剩余车位
@property (nonatomic,copy) NSString * remainder;
//停车场图片
@property (nonatomic,copy) NSString * parkimg;
//停车场规模
@property (nonatomic,copy) NSString *scale;

@property (nonatomic,copy)NSString *isvalid;

@property (nonatomic,copy) NSString *subtitle;
@end
