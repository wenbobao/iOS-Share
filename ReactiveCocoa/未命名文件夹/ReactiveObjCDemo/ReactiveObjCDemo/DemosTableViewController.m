//
//  DemosTableViewController.m
//  ReactiveObjCDemo
//
//  Created by bob on 17/3/27.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "DemosTableViewController.h"
#import "XXButtonViewController.h"
#import "XXTableViewController.h"
#import "XXTextFieldViewController.h"

@interface DemosTableViewController ()

@property (nonatomic, strong) NSArray *datasource;

@end

@implementation DemosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ReactiveCocoa Demo";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.datasource[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.datasource[indexPath.row];
    [self didSelectCellWithTitle:title];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"UIButton"]) {
        viewController = [[XXButtonViewController alloc] init];
    }
    else if ([title isEqualToString:@"UITableView"]) {
        viewController = [[XXTableViewController alloc] init];
    }
    else if ([title isEqualToString:@"UITextField"]) {
        viewController = [[XXTextFieldViewController alloc] init];
    }
//    else if ([title isEqualToString:@"UIAlertView"]) {
//        viewController = [[XXAlertViewController alloc] init];
//    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Getter

- (NSArray *)datasource {
    if (!_datasource) {
        _datasource = @[@"UIButton", @"UITextField", @"UITableView", @"UIControl", @"UIGestureRecognizer"];
    }
    return _datasource;
}

@end
