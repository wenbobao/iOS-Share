//
//  NetViewModel.m
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/3.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "NetViewModel.h"

@implementation NetViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.netCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"q"] = @"基础";
            
            [[AFHTTPSessionManager manager]GET:@"https://api.douban.com/v2/book/search" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                // 请求成功调用
                // 把数据用信号传递出去
                [subscriber sendNext:responseObject];
                
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
            
            return nil;
        }];
        
        return [requestSignal map:^id(NSDictionary *value){
            
            NSMutableArray *modelArr = [NSMutableArray new];
            NSMutableArray *dictArr = value[@"books"];
            [dictArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [modelArr addObject:obj[@"title"]];
            }];
            return modelArr;
        }];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.models[indexPath.row];
    return cell;
}

@end
