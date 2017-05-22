//
//  LoginViewModel.m
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/2.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.validLoginSignal = [[RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password)] reduce:^(NSString *username, NSString *password) {
       return @(username.length > 0 && password.length > 0);
    }] distinctUntilChanged];
    
    @weakify(self)
    self.loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        @strongify(self)
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            // 模仿网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([self.username isEqualToString:@"user"] && [self.password isEqualToString:@"123"]) {
                    [subscriber sendNext:@"success"];
                }
                else {
                    [subscriber sendNext:@"failure"];
                }
                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if ([x isEqualToString:@"success"]) {
            NSLog(@"登陆成功");
            [[[UIAlertView alloc]initWithTitle:@"Info" message:@"login success" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        }
        else {
            NSLog(@"登陆失败");
            [[[UIAlertView alloc]initWithTitle:@"Info" message:@"login failure" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        }
    }];
    [[self.loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x isEqualToNumber:@(YES)]) {
            NSLog(@"登陆中");
            
           
        }
        else {
            NSLog(@"信号结束");
            
        }
    }];
}

@end
