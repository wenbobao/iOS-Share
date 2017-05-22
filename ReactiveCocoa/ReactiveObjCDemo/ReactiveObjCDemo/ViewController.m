//
//  ViewController.m
//  ReactiveObjCDemo
//
//  Created by bob on 17/3/23.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (copy, nonatomic) NSString *username;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self rac_delegate];
    
//    @weakify(self);
}

#pragma mark - delegate

- (void)rac_delegate
{
    self.userNameTextField.delegate = self;
    [[self rac_signalForSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    

}

#pragma mark - Action

- (void)rac_action
{
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        
        NSLog(@"hello, RAC");
        
    }];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
}

- (void)loginAction:(UIButton *)sender
{
    NSLog(@"hello, Action");
}

#pragma mark - 通知

- (void)rac_notification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotificationCenter:) name:@"" object:nil];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
    }];
}

- (void)receiveNotificationCenter:(NSNotification *)noti
{
    
}

#pragma mark - KVO

- (void)rac_kvo
{
//    [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//
//    RACObserve(self, username);
    // KVO
    [RACObserve(self, username) subscribeNext:^(NSString *username) {
        // 用户名发生了变化
        
    }];
    
    self.username = @"asdads";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"username"]) {
        
    }
}

// 基本概念
// 1.流
// 流是值的序列抽象，你可以认为一个流就像一条水管，而值就是流淌在水管中的水，值从管道的一端流入，从管道的另一端流出。当值从管道的另一端流出时，我们可以读取过去所有的值，甚至是刚刚进入管道的值。
// 值的序列？什么鬼？ 以我们当前的认知水平来说，她就像是一个数组，一个列表

// 高阶映射
- (void)testRACMap
{
    NSArray *array = @[@1,@2,@3];
    
    // 使用rac_sequence 可以轻松将数组转化为一个流
    
    RACSequence *stream = [array rac_sequence];
    // Sequence --> 序列
    // 刚才说到stream，现在又是Sequence？
    // 说明一下 RACSequence 是 RACStream的一个子类，是两种特定类型的流的一种
    
    stream = [stream map:^id _Nullable(id  _Nullable value) {
        return @(pow([value integerValue], 2));
    }];
    
    // 流映射后还是流, 怎么才能得到数组呢？
//    NSLog(@"%@", [stream array]);
    NSLog(@"%@", stream);
    
    // 我们可以合并上面的方法调用来避免污染变量的作用域
    NSLog(@"%@",[[[array rac_sequence] map:^id _Nullable(id  _Nullable value) {
        return @(pow([value integerValue], 2));
    }] array]);
    
    // 总结 1. 将数组转化成了一个序列类型的流
    // 2. 对流进行映射得到一个新的流
    // 3. 将流的值转化为数组
}

// 高阶过滤
- (void)testRACFilter
{
    NSArray *array = @[@1,@2,@3];
    NSLog(@"%@", [[[array rac_sequence] filter:^BOOL(id  _Nullable value) {
        return [value integerValue] % 2 == 0;
    }]array]);
}

// 高阶折叠
- (void)testRACFold
{
    NSArray *array = @[@1,@2,@3];
    NSLog(@"%@", [[[array rac_sequence] map:^id _Nullable(id  _Nullable value) {
        return [value stringValue];
    }] foldLeftWithStart:@"" reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        return [accumulator stringByAppendingString:value];
    }]);
}

// 2.信号
// 信号是另一种类型的流，与序列流相反，信号是push-driven的。
// 新的值能够通过管道发布但不能像pull-driven一样在管道中获取，
// 他们所抽象出来的数据会在未来的某个时间传送过来

// push-driven : 在创建信号的时候，信号不会被立即赋值，之后才会被赋值（例如 网络请求回来的结果或者 任意用户输入的结果）
// pull-driven : 在创建信号时同时序列中的值会被确定下来，我们可以从流中一个个的查询值

// 信号能够发送三种类型的值
// next values 代表下一个发送到管道中的值
// error value 代表signal 无法成功完成
// Completion value 代表signal 成功完成

// 一个signal 只能发送一次error 或 completion ,发送后就不会再发送任何其他的value

// 信号时ReactiveCocoa的核心组件之一，ReactiveCocoa 为 UIKit的每一个控件内置了一套信号选择器， 例如 UITextField 的 rac_textSignal, UITextField每一次按键的响应，都会通过它发送出去。

// 3. 订阅
// 当你随时想知道某一个值的改变是（不管是next,error,completion）, 你就会订阅流

- (void)testRACCreateSignal
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
         // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:@"hello"];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
        }];
    }];
    
    
    // 3.订阅信号,才会激活信号.
    [signal subscribeNext:^(id  _Nullable x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
}

- (void)testRACTextSignalSubscribe
{
//    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"New Value: %@", x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"Eoor: %@", error);
//    } completed:^{
//        NSLog(@"completed");
//    }];
//    
//    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"New Value: %@", x);
//    }];
    
//    [[self.userNameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return @(value.length);
//    }] filter:^BOOL(id  _Nullable value) {
//        
//    }];
    
    RAC(self.userNameTextField, text) = [self.userNameTextField.rac_textSignal map:^(NSString * _Nullable x) {
        if (x.length <= 15) {
            return x;
        }
        return [x substringToIndex:15];
    }];
    
//    RACDisposable
    // 当你订阅一个信号的时候，实际上你创建了一个订阅者
}

// 4. 状态推导
// 状态推导是ReactiveCocoa的另一个核心组件，这里指的是把属性抽象为流
// 例子
// 只有当用户输入@时，button 可以使用，同时我们希望textfield 的text 颜色给用户提供反馈
- (void)testRacProprityBind
{
    // 这里将button的enabled属性与我们创建的信号绑定
    RAC(self.loginButton, enabled) = [self.userNameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    
    
    
    // RAC()宏需要两个参数， 对象和对象的某个属性的keyPath,然后将表达式右边的值和keyPath做一个单向的绑定，这个值必须是一个NSObject类型
}

- (void)testRacProprityBind2
{
    RACSignal *vaildEmailSignal = [self.userNameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    
    RAC(self.loginButton, enabled) = vaildEmailSignal;
    
    RAC(self.userNameTextField, textColor) = [vaildEmailSignal map:^id _Nullable(id  _Nullable value) {
        if ([value boolValue]) {
            return [UIColor greenColor];
        }
        else {
            return [UIColor redColor];
        }
    }];
}

// 5 指令

// 其实我们绑定UIButton的enabled属性并不是最佳实践，因为UIButton 增加了一个ReactiveCocoa的类和一条指令。
// UIButton 的 rac_command可以为我们监控enabled 属性。

- (void)testRACCommand1
{
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"执行命令");
        // 创建空信号,必须返回信号
//        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"请求数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 3.订阅RACCommand中的信号
//    [command.executionSignals subscribeNext:^(id  _Nullable x) {
//         [x subscribeNext:^(id  _Nullable x) {
//             NSLog(@"%@",x);
//         }];
//    }];
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
//    [[command.executing skip:1] subscribeNext:^(id x) {
//        
//        if ([x boolValue] == YES) {
//            // 正在执行
//            NSLog(@"正在执行");
//            
//        }else{
//            // 执行完成
//            NSLog(@"执行完成");
//        }
//        
//    }];
    [command.executing subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    // 5.执行命令
    [command execute:@1];
}

- (void)testRACCommand2
{
    RACSignal *vaildEmailSignal = [self.userNameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    
    self.loginButton.rac_command = [[RACCommand alloc]initWithEnabled:vaildEmailSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"button press");
        // 返回空信号
        return [RACSignal empty];
    }];
}

- (void)initComponents
{
    RAC(self.loginButton, enabled) =  [[RACSignal combineLatest:@[self.userNameTextField.rac_textSignal,self.passwordTextField.rac_textSignal] reduce:^(NSString *username, NSString *password){
        return @(username.length > 0 && password.length > 0);
    }]distinctUntilChanged];
    
    self.loginButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

// 6. RACSubject
// RACSubject 是一个有趣的信号类型，在‘ReactiveCocoa’的世界中他是一个可变的状态，它是一个可以主动发送新值的信号。出于这个原因，除非特殊情况，我们不推荐使用它。

//RACReplaySubject与RACSubject区别:
//RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。

- (void)testRACSubject
{
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
}

- (void)testRACReplaySubject
{
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@1];
    
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者收到的数据%@",x);
    }];
    
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者收到的数据%@",x);
    }];
}

// 7. 热信号，冷信号

// 信号是典型的懒鬼，除非有人订阅他们，他们是不会启动并发送的。每增加一个订阅，他们都会重复的多发送一个信号。 这种称为冷信号。
// 有的时候我们希望让信号立即工作，热信号，这种信号用的非常少

// 8. 组播



@end
