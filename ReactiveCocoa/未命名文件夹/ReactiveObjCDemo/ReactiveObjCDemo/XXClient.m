//
//  XXClient.m
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/5.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "XXClient.h"

@implementation XXClient

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(id)parameters
{
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
         __block NSURLSessionDataTask *task = [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [subscriber sendNext:responseObject];
             [subscriber sendCompleted];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, URLString, parameters];
}

@end
