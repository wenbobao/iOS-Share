//
//  NetDataTableViewController.m
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/3.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "NetDataTableViewController.h"
#import "NetViewModel.h"
#import <HandyFrame/UIView+LayoutMethods.h>

@interface NetDataTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NetViewModel *netViewModel;
@end

@implementation NetDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    self.tableView.dataSource = self.netViewModel;
    
    [self.view addSubview:self.tableView];
    
    
    @weakify(self)
    [[self.netViewModel.netCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.netViewModel.models = x;
        [self.tableView reloadData];
    }];
}

- (NetViewModel *)netViewModel
{
    if (!_netViewModel) {
        _netViewModel = [[NetViewModel alloc] init];
    }
    return _netViewModel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
