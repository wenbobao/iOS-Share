//
//  View1.m
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/5.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "View1.h"

#import "ViewController1.h"

@implementation View1

- (IBAction)buttonClick:(UIButton *)btn {
//    BOOL r = self.b(btn.tag);
    [[self.cmd execute:@(btn.tag)] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

@end
