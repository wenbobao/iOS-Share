//
//  ViewController.m
//  RXCollectionsDemo
//
//  Created by bob on 17/3/23.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "ViewController.h"
#import <RXCollections/RXCollection.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testFlod3];
}

- (void)test1
{
    NSArray *array = @[@1,@2,@3];
    
    for (NSNumber *number in array) {
        NSLog(@"%@", number);
    }
 
    [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
}

#pragma mark - 高阶映射
// 1. 高阶函数 －》 映射［map］,映射是在函数的层次上把一个列表变为相同长度的另一个列表，原始列表中的每一个值，在新的列表中都有一个对应的值，如下所示是一个平方数的映射：
// map(1,2,3) => (1,4,9) 当然这只是一个伪代码，一个高阶函数会返回另一个函数而不是一个列表
//
- (void)testMap1
{
    NSArray *array = @[@1,@2,@3];
    NSLog(@"%@", array);
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSNumber *number in array) {
        [mutableArray addObject:@(pow([number integerValue], 2))];
    }
    NSArray *mapArray = [NSArray arrayWithArray:mutableArray];
    NSLog(@"%@", mapArray);
}

- (void)testMap2
{
    NSArray *array = @[@1,@2,@3];
    NSLog(@"%@", array);
    
    NSArray *mapArray = [array rx_mapWithBlock:^id(id each) {
        return @(pow([each integerValue], 2));
    }];
    
    NSLog(@"%@", mapArray);
}

// 简直完美，请注意rx_mapWithBlock,并不是一个真正的函数映射，因为它不是技术上的高阶函数（它没有返回一个函数）

#pragma mark - 高阶过滤
// 2. 过滤器 --> 一个列表通过过滤,能够返回一个只包含了原列表中符合条件的元素的新列表

- (void)testFilter1
{
    NSArray *array = @[@1,@2,@3];
    NSLog(@"%@", array);
    
    NSArray *filterArray = [array rx_filterWithBlock:^BOOL(id each) {
        return [each integerValue] % 2 == 0;
    }];
    
    NSLog(@"%@", filterArray);
}

- (void)testFilter2
{
    NSArray *array = @[@1,@2,@3];
    NSLog(@"%@", array);
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSNumber *number in array) {
        if ([number integerValue] % 2 ==0) {
            [mutableArray addObject:number];
        }
    }
    NSArray *filterArray = [NSArray arrayWithArray:mutableArray];
    NSLog(@"%@", filterArray);
}

// 你可能想这样字写代码写了成百上千次。通过使用 高阶过滤、高阶映射类似的高阶函数，我们能够把这张繁琐又复杂的任务抽象出来，轻松工作，轻松生活。。。

#pragma mark - 高阶折叠

// 3. Flod 是一个有趣的高阶函数，它把列表中的所有元素变为一个值，一个简单的高阶折叠函数能够用来给数据整组求和

- (void)testFlod1
{
    NSArray *array = @[@1,@2,@3];
    
    NSNumber *sum = [array rx_foldWithBlock:^id(id memo, id each) {
        return @([memo integerValue] + [each integerValue]);
    }];
    
    NSLog(@"%@", sum);
}

// 其中memo是上一次合并后的结果，初始值为0
// 我们还可以给memo赋初始值

- (void)testFlod2
{
    NSArray *array = @[@1,@2,@3];
    
    NSNumber *sum = [array rx_foldInitialValue:@5 block:^id(id memo, id each) {
        return @([memo integerValue] + [each integerValue]);
    }];
    NSLog(@"%@", sum);
}

- (void)testFlod3
{
    NSArray *array = @[@1,@2,@3];
    
    NSString *value = [[array rx_mapWithBlock:^id(id each) {
        return [each stringValue];
    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        return [memo stringByAppendingString:each];
    }];
    
    NSLog(@"%@", value);
}

@end
