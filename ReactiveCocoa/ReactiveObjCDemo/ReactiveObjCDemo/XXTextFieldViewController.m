//
//  XXTextFieldViewController.m
//  ReactiveObjCDemo
//
//  Created by bob on 17/3/27.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "XXTextFieldViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <HandyFrame/UIView+LayoutMethods.h>

@interface XXTextFieldViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *normalTextFiled;

@property (nonatomic, strong) UITextField *racTextFiled;

@end

@implementation XXTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.normalTextFiled];
    
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple *x) {
        UITextField *textFiled = x.first;
        NSLog(@"输入的text为: %@", textFiled.text);
    }];
    
    self.normalTextFiled.delegate = self;
    
    [self.view addSubview:self.racTextFiled];
    
    [self.racTextFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    
    
}

#pragma mark - Getter

- (UITextField *)normalTextFiled {
    if (!_normalTextFiled) {
        _normalTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 200, 50)];
        _normalTextFiled.layer.borderColor = [UIColor redColor].CGColor;
        _normalTextFiled.layer.borderWidth = 1;
    }
    return _normalTextFiled;
}

- (UITextField *)racTextFiled {
    if (!_racTextFiled) {
        _racTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, 200, 200, 50)];
        _racTextFiled.layer.borderColor = [UIColor redColor].CGColor;
        _racTextFiled.layer.borderWidth = 1;
    }
    return _racTextFiled;
}

#pragma mark - UITextFieldDelegate

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"输入的text为: %@", textField.text);
//}

@end
