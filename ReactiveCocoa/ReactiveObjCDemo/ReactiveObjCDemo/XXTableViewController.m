//
//  XXTableViewController.m
//  ReactiveObjCDemo
//
//  Created by bob on 17/3/27.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "XXTableViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <HandyFrame/UIView+LayoutMethods.h>

@interface XXTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
//    Why can't use datasource with source?
    [self rac_signalForSelector:@selector(tableView:numberOfRowsInSection:) fromProtocol:@protocol(UITableViewDataSource)];
//    ReactiveCocoa, like all Reactive Extensions-based frameworks,is designed around a push-based API for operating on a series of values. That is, you have some source of values and then you use signal composition to react to the arrival of new values.
//        
//    On the other hand, the "data source" pattern common to many Cocoa frameworks requires that you provide a pull-based API. That is, you have some source of values, and you make those values available to other objects by implementing query methods like -tableView:numberOfRowsInSection:. The other objects will generally call these methods synchronously when they need to know the number of table rows in the specified section.
//        
//    These two concepts are pretty much at odds with each other. It would be hard to "implement a data source using ReactiveCocoa" (though ReactiveCocoa can certainly be useful to other areas of your app).
    
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple *arguments) {
        NSLog(@"tableView:didSelectRowAtIndexPath:%@", arguments);
        UITableView *tableview = arguments.first;
        NSIndexPath *indexPath = arguments.second;
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        NSLog(@"click %li", indexPath.row);
    }];
    
    //这里是个坑,必须将代理最后设置,否则信号是无法订阅到的
    //雷纯峰大大是这样子解释的:在设置代理的时候，系统会缓存这个代理对象实现了哪些代码方法
    //如果将代理放在订阅信号前设置,那么当控制器成为代理时是无法缓存这个代理对象实现了哪些代码方法的
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tableView fill];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"hello";
    return cell;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
