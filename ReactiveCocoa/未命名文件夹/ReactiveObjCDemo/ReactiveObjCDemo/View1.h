//
//  View1.h
//  ReactiveObjCDemo
//
//  Created by bob on 2017/5/5.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ReactiveObjC/ReactiveObjC.h>

@interface View1 : UIView

//@property (copy, nonatomic) BOOL (^b)(NSInteger tag);

@property (strong, nonatomic) RACCommand *cmd;

@end
