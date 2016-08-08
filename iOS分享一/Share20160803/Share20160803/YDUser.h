//
//  YDUser.h
//  Share20160803
//
//  Created by bob on 16/8/8.
//  Copyright © 2016年 __company__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDUser : NSObject

@property(nonatomic, readonly, strong)NSString *name;

@property(nonatomic, readonly, assign)NSInteger age;

+ (instancetype)modleWithName:(NSString *)name age:(NSInteger )age;

@end
