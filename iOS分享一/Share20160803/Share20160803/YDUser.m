//
//  YDUser.m
//  Share20160803
//
//  Created by bob on 16/8/8.
//  Copyright © 2016年 __company__. All rights reserved.
//

#import "YDUser.h"

@interface YDUser()

@property(nonatomic, readwrite, strong)NSString *name;

@property(nonatomic, readwrite, assign)NSInteger age;

@property (nonatomic, copy) NSArray * __nonnull items;

@property (nonatomic, copy, nonnull) NSArray * item1s;

@end

@implementation YDUser

+ (instancetype)modleWithName:(NSString *)name age:(NSInteger)age
{
    YDUser *model = [[YDUser alloc] init];
    model.name = name;
    model.age = age;
    return model;
}

@end
