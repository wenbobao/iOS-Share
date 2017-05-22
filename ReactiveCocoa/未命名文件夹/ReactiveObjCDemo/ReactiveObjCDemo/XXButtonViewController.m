//
//  XXButtonViewController.m
//  ReactiveObjCDemo
//
//  Created by bob on 17/3/27.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "XXButtonViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <HandyFrame/UIView+LayoutMethods.h>

@interface XXButtonViewController ()

@property (nonatomic, strong) UIButton *normalButton;

@property (nonatomic, strong) UIButton *racButton;

@end

@implementation XXButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.normalButton];
    [self.normalButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.racButton];
    self.racButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"I'm rac button , I'm clicked");
        return [RACSignal empty];
    }];
    
//    [[self.racButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//         NSLog(@"I'm rac button , I'm clicked");
//    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    item.title = @"OK1";
    item.style = UIBarButtonItemStylePlain;
    item.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"I'm BarButtonItem1 , I'm clicked");
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithTitle:@"OK2" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClick:)], item];
}

- (void)buttonClick:(UIButton *)sender {
    NSLog(@"I'm normal button , I'm clicked");
}

- (void)barButtonClick:(UIBarButtonItem *)sender {
    NSLog(@"I'm BarButtonItem2, I'm clicked");
}

- (UIButton *)normalButton {
    if (!_normalButton) {
        _normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_normalButton setTitle:@"normal button" forState:UIControlStateNormal];
        [_normalButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_normalButton setFrame:CGRectMake(self.view.centerX - 100, self.view.centerY - 50, 200, 100)];

    }
    return _normalButton;
}

- (UIButton *)racButton {
    if (!_racButton) {
        _racButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_racButton setTitle:@"rac button" forState:UIControlStateNormal];
        [_racButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_racButton setFrame:CGRectMake(self.view.centerX - 100, self.view.centerY + 100, 200, 100)];
        
    }
    return _racButton;
}

@end
