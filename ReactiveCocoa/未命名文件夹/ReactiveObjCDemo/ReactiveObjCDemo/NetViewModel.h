//
//  NetViewModel.h
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/3.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <AFNetworking/AFNetworking.h>

@interface NetViewModel : NSObject <UITableViewDataSource>

// 请求命令
@property (nonatomic, strong) RACCommand *netCommand;

//模型数组
@property (nonatomic, strong) NSArray *models;

@end
