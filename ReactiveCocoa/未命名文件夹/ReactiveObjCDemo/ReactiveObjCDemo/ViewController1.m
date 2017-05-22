//
//  ViewController1.m
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/5.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "ViewController1.h"

#import "View1.h"

@interface ViewController1 ()
@property (strong, nonatomic) View1 *tabbar;
@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabbar = [[[NSBundle mainBundle] loadNibNamed:@"View1" owner:nil options:nil] firstObject];
    self.tabbar.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    [self.view addSubview:self.tabbar];
    
//    self.tabbar.b = ^(NSInteger tag) {
//        self.label.text = [NSString stringWithFormat:@"%d", tag];
//    };
    self.tabbar.cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        self.label.text = [NSString stringWithFormat:@"%@", input];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@(YES)];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

@end
