//
//  MyModel.m
//  DuDuCar
//
//  Created by 黄泽 on 2017/5/13.
//  Copyright © 2017年 黄泽. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    if ([key isEqualToString:@"typename"]) {
        _typenamed = value;
    }
    
    
}
@end
