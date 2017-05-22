//
//  LoginViewModel.h
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/2.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) RACSignal *validLoginSignal;

@property (nonatomic, strong) RACCommand *loginCommand;

@end
