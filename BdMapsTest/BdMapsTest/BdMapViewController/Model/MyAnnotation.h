//
//  MyAnnotation.h
//  DuDuCar
//
//  Created by 黄泽 on 2017/5/13.
//  Copyright © 2017年 黄泽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "MyModel.h"
/**
 *  大头针枚举
 */
typedef NS_ENUM(NSInteger,PinType) {
    /**
     *  超市
     */
    SUPER_MARKET = 0,
    /**
     *  火场
     */
    CREMATORY,
    /**
     *  景点
     */
    INTEREST,
};

@interface MyAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//主要用来识别图
@property (nonatomic,retain) NSNumber *type;//类型

@property (nonatomic, strong) MyModel *model;

@end
