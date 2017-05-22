//
//  XXClient.h
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/5.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "AFHTTPSessionManager.h"

@interface XXClient : AFHTTPSessionManager

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(id)parameters;

@end
