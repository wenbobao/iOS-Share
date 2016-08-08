//
//  ViewController.m
//  Share20160803
//
//  Created by bob on 16/8/4.
//  Copyright © 2016年 __company__. All rights reserved.
//

#import "ViewController.h"
#import "YDUser.h"

@interface ViewController ()

@property(nonatomic, strong)NSMutableArray* userOnes;

@property(nonatomic, strong)NSMutableArray<YDUser *> * userTwos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    YDUser *user1 = [YDUser modleWithName:@"zhangsan" age:18];
    YDUser *user2 = [YDUser modleWithName:@"lisa" age:18];
    YDUser *user3 = [YDUser modleWithName:@"wangwu" age:18];
    
    _userOnes = @[user1,user2,user3,@4].mutableCopy;
    
//    _userTwos = @[user1,user2,user3];
    
    _userTwos = [NSMutableArray arrayWithObjects:user1,user2,user3, nil];
    [_userTwos addObject:@1];
    
    NSLog(@"%@",[_userTwos lastObject]);
    
//    NSLog(@"%li",_userOnes.firstObject.age);
    
    NSLog(@"%li",_userTwos.firstObject.age);
    
//    [[NSArray array]mask];
    
    
    [self share1];
}

- (void)share1
{
    //nil:指向OC中对象的空指针 ex: NSString *value = nil;
    //Nil:指向OC中类的空指针   ex: Class class = Nil;
    //NULL:指向其他类型的空指针，（如：基本类型、C类型）的空指针 ex: int *pointerInt = NULL;
    //NSNull 是Foundation的一个类,有一个类方法 +null,返回一个空值对象,用来在NSArray和NSDictionary中加入非nil（表示列表结束）的空值.
    /*
     若obj为nil：
    ［obj message］将返回NO,而不是NSException
     若obj为NSNull:
    ［obj message］将抛出异常NSException
     */
    
    //nil是一个对象指针为空，Nil是一个类指针为空，NULL是基本数据类型为空。
    
    
//  example 1: The values1 will only have obj1,
    NSObject *obj1 = [NSObject new];
    NSObject *obj2 = nil;
    NSObject *obj3 = [NSObject new];
    NSArray *values1 = [NSArray arrayWithObjects:obj1,obj2,obj3,nil];
    NSLog(@"values1 count : %li ",values1.count);
    
    //  example 2: The values2 will  have obj3,
//    NSObject *obj1 = [NSObject new];
//    NSObject *obj2 = [NSNull null];
//    NSObject *obj3 = [NSObject new];
//    NSArray *values2 = [NSArray arrayWithObjects:obj1,obj2,obj3,nil];
//    NSLog(@"values1 count : %li ",values2.count);
    
    //example 3:
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    mutableDictionary[@"someKey"] = [NSNull null]; // Sets value of NSNull singleton for `someKey`
    NSLog(@"Keys: %@", [mutableDictionary allKeys]); // @[@"someKey"]

}

- (void)share2
{
    //==  比较地址是否相等  如 基本数据类型 枚举
    //isEqual: 首先判断两个对象是否类型一致在, 再判断具体内容是否一致，如果类型不同直接return no.
    //isEqualToString: 这个直接判断字符串内容，当然你要确保比较的对象保证是字符串。
    
    //example 1
//    int a = 5;
//    int b = 5.0;
//    if (a == b) {
//        NSLog(@"==");
//    }else {
//        NSLog(@"!=");
//    }
    
    //example 2
    NSString *string1 = @"hello";
    NSString *string2 = @"hello";
    if ([string1 isEqualToString:string2]) {
        NSLog(@"isEqualToString");
    }else {
        NSLog(@"!isEqualToString");
    }
    if ([string1 isEqual:string2]) {
        NSLog(@"isEqual");
    }else {
        NSLog(@"!isEqual");
    }
}

- (void)share3
{
    NSString *str;// NSString *str = nil;
    // 1.
    if ([str isEqualToString:@""]) {
        NSLog(@"str为空");
    }else{
        NSLog(@"str不为空");
    }
    // 2.
    if ([str isEqualToString:@""] || str == nil) {
        NSLog(@"str为空");
    }else{
        NSLog(@"str不为空");
    }
    // 3.
    if (str.length == 0) {
        NSLog(@"str为空");
    }else{
        NSLog(@"str不为空");
    }
}


//@符号编译器 也可以说说成Objective-C 有关的简写符号
- (void)share4
{
    NSMutableArray *mArray = @[].mutableCopy;
    NSMutableDictionary *mDictionary = @{}.mutableCopy;
}

@end
