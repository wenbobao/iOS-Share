//
//  ViewController.m
//  ReactiveObjCDemo
//
//  Created by bob on 17/3/23.
//  Copyright © 2017年 wenbobao. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginViewModel.h"
#import "NetDataTableViewController.h"
#import "XXClient.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *fetchButton;

@property (copy, nonatomic) NSString *username;

@property (strong, nonatomic) LoginViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self rac_netRequest1];
}

#pragma mark - 常用场景

#pragma mark delegate

- (void)rac_delegate
{
    self.userNameTextField.delegate = self;
    [[self rac_signalForSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark Action

- (void)rac_action
{
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        NSLog(@"hello, RAC");
    }];
}

- (void)loginAction:(UIButton *)sender
{
    NSLog(@"hello, Action");
}

#pragma mark 通知

- (void)rac_notification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotificationCenter:) name:@"" object:nil];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
    }];
}

- (void)receiveNotificationCenter:(NSNotification *)noti
{
    
}

#pragma mark KVO

- (void)rac_kvo
{
    [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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

#pragma mark - RAC入门(一)

#pragma mark 高阶函数
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

#pragma mark 信号
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
    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"New Value: %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"Eoor: %@", error);
    } completed:^{
        NSLog(@"completed");
    }];
    
    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"New Value: %@", x);
    }];
    
    [[self.userNameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }] filter:^BOOL(NSNumber *value) {
        return value.integerValue > 5;
    }];
    
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
    
    
    self.loginButton.rac_command = command;
    
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


#pragma mark - RAC 入门 (二) 及项目中的应用

#pragma mark - 1. 核心bind

- (void)rac_bindTest
{
    // bind方法参数:需要传入一个返回值是RACStreamBindBlock的block参数
    // RACStreamBindBlock是一个block的类型，返回值是信号，参数（value,stop），因此参数的block返回值也是一个block。
    
    // RACStreamBindBlock:
    // 参数一(value):表示接收到信号的原始值，还没做处理
    // 参数二(*stop):用来控制绑定Block，如果*stop = yes,那么就会结束绑定。
    // 返回值：信号，做好处理，在通过这个信号返回出去，一般使用RACReturnSignal,需要手动导入头文件RACReturnSignal.h。
    
    // bind方法使用步骤:
    // 1.传入一个返回值RACStreamBindBlock的block。
    // 2.描述一个RACStreamBindBlock类型的bindBlock作为block的返回值。
    // 3.描述一个返回结果的信号，作为bindBlock的返回值。
    // 注意：在bindBlock中做信号结果的处理。
    
    // 底层实现:
    // 1.源信号调用bind,会重新创建一个绑定信号。
    // 2.当绑定信号被订阅，就会调用绑定信号中的didSubscribe，生成一个bindingBlock。
    // 3.当源信号有内容发出，就会把内容传递到bindingBlock处理，调用bindingBlock(value,stop)
    // 4.调用bindingBlock(value,stop)，会返回一个内容处理完成的信号（RACReturnSignal）。
    // 5.订阅RACReturnSignal，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    [[self.userNameTextField.rac_textSignal bind:^{
        return ^(id value, BOOL *stop){
            return [RACSignal return:[NSString stringWithFormat:@"输出:%@", value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - 2. 映射
// flattenMap，Map用于把源信号内容映射成新的内容。

//FlatternMap和Map的区别
//1.FlatternMap中的Block返回信号。
//2.Map中的Block返回对象。
//3.开发中，如果信号发出的值不是信号，映射一般使用Map
//4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。

- (void)rac_flattenMapTest
{
    // flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型。
    
    // flattenMap使用步骤:
    // 1.传入一个block，block类型是返回值RACStream，参数value
    // 2.参数value就是源信号的内容，拿到源信号的内容做处理
    // 3.包装成RACReturnSignal信号，返回出去。
    
    // flattenMap底层实现:
    // 0.flattenMap内部调用bind方法实现的,flattenMap中block的返回值，会作为bind中bindBlock的返回值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 2.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 3.调用bindBlock，内部就会调用flattenMap的block，flattenMap的block作用：就是把处理好的数据包装成信号。
    // 4.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 5.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    [[self.userNameTextField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        
        // block什么时候 : 源信号发出的时候，就会调用这个block。
        
        // block作用 : 改变源信号的内容。
        
        // 返回值：绑定信号的内容.
        return [RACSignal return:[NSString stringWithFormat:@"输出:%@", value]];
    }]subscribeNext:^(id  _Nullable x) {
        // 订阅绑定信号，每当源信号发送内容，做完处理，就会调用这个block。
        NSLog(@"%@", x);
    }];
}

- (void)rac_mapTest
{
    // Map作用:把源信号的值映射成一个新的值
    
    // Map使用步骤:
    // 1.传入一个block,类型是返回对象，参数是value
    // 2.value就是源信号的内容，直接拿到源信号的内容做处理
    // 3.把处理好的内容，直接返回就好了，不用包装成信号，返回的值，就是映射的值。
    
    // Map底层实现:
    // 0.Map底层其实是调用flatternMap,Map中block中的返回的值会作为flatternMap中block中的值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 3.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 4.调用bindBlock，内部就会调用flattenMap的block
    // 5.flattenMap的block内部会调用Map中的block，把Map中的block返回的内容包装成返回的信号。
    // 5.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 6.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    [[self.userNameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [NSString stringWithFormat:@"输出:%@", value];
    }]subscribeNext:^(id  _Nullable x) {
        // 订阅绑定信号，每当源信号发送内容，做完处理，就会调用这个block。
        NSLog(@"%@", x);
    }];
}

#pragma mark - 3. 组合

// concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
- (void)rac_concatTest
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        
        return nil;
    }];
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // concat底层实现:
    // 1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
    // 2.didSubscribe中，会先订阅第一个源信号（signalA）
    // 3.会执行第一个源信号（signalA）的didSubscribe
    // 4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
    // 5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
    // 6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
    // 7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
}

//then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
- (void)rac_thenTest
{
    // then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    // 注意使用then，之前信号的值会被忽略掉.
    // 底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@2];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@", x);
    }];
}

// merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用

- (void)rac_mergeTest
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 底层实现：
    // 1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
    // 2.每发出一个信号，这个信号就会被订阅
    // 3.也就是合并信号一被订阅，就会订阅里面所有的信号。
    // 4.只要有一个信号被发出就会被监听。
}

//zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。

- (void)rac_zipWithTest
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    // 压缩信号A，信号B
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(RACTuple *x) {
        
        RACTupleUnpack(NSNumber *n1, NSNumber *n2) = x;
        NSLog(@"%@", n1);
        NSLog(@"%@", n2);
        
    }];
    
    // 底层实现:
    // 1.定义压缩信号，内部就会自动订阅signalA，signalB
    // 2.每当signalA或者signalB发出信号，就会判断signalA，signalB有没有发出个信号，有就会把最近发出的信号都包装成元组发出。
    
}

//combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
- (void)rac_combineLatestTest
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];

    // 把两个信号组合成一个信号,跟zip一样，没什么区别
    RACSignal *combineSignal = [signalA combineLatestWith:signalB];
    [combineSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 底层实现：
    // 1.当组合信号被订阅，内部会自动订阅signalA，signalB,必须两个信号都发出内容，才会被触发。
    // 2.并且把两个信号组合成元组发出。
}

//reduce聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
- (void)rac_reduceTest
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 聚合
    // 常见的用法，（先组合在聚合）。combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
    // reduce中的block简介:
    // reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    // reduceblcok的返回值：聚合信号之后的内容。
    RACSignal *reduceSignal = [RACSignal combineLatest:@[signalA, signalB] reduce:^id (NSNumber *num1, NSNumber *num2){
         return [NSString stringWithFormat:@"%@ %@",num1,num2];
    }];
    [reduceSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // 底层实现:
    // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。
}

#pragma mark - 4. 过滤

//filter:过滤信号，使用它可以获取满足条件的信号.

- (void)rac_filterTest
{
    // 每次信号发出，会先执行过滤条件判断.
    [[self.userNameTextField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
}

//ignore:忽略完某些值的信号.

- (void)rac_ignoreTest
{
    // 每次信号发出，会先执行过滤条件判断.
    [[self.userNameTextField.rac_textSignal ignore:@"1"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
}

//distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。

- (void)rac_distinctUntilChangedTest
{
    // 在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    [[self.userNameTextField.rac_textSignal distinctUntilChanged] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
}

//take:从开始一共取N次的信号
- (void)rac_takeTest
{
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal take:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
}

//takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号

- (void)rac_takeLastTest
{
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    // 必须发送完成
    [signal sendCompleted];
}

//takeUntil:(RACSignal *):获取信号直到某个信号执行完成

- (void)rac_takeUntilTest
{
    // 监听文本框的改变直到当前对象被销毁
    [self.userNameTextField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
}

//skip:(NSUInteger):跳过几个信号,不接受。

- (void)rac_skipTest
{
    // 监听文本框的改变直到当前对象被销毁
    [[self.userNameTextField.rac_textSignal skip:1] subscribeNext:^(NSString * _Nullable x) {
         NSLog(@"%@",x);
    }];
}

//switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。

- (void)rac_switchToLatestTest
{
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
//    [signalOfSignals subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];

    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
}

#pragma mark - 5. 秩序 (doNext, doCompleted)

//doNext: 执行Next之前，会先执行这个Block
//doCompleted: 执行sendCompleted之前，会先执行这个Block

- (void)rac_orderTest
{
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id  _Nullable x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext");;
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - 6. 线程

//deliverOn: 内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用。

//subscribeOn: 内容传递和副作用都会切换到制定线程中。

#pragma mark - 7. 时间
//timeout：超时，可以让一个信号在一定的时间后，自动报错。

- (void)rac_timeoutTest
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        // 1秒后会自动调用
        NSLog(@"%@",error);
    }];
}

//interval 定时：每隔一段时间发出信号

- (void)rac_intervalTest
{
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

//delay 延迟发送next。

- (void)rac_delayTest
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }] delay:2];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - 8. 重复

//retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
- (void)rac_retryTest
{
    __block int i = 1;
    
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        if (i == 10) {
            [subscriber sendNext:@(i)];
        }
        else {
            [subscriber sendError:nil];
        }
        
        i++;
        return nil;
        
    }] retry] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

//replay重放：当一个信号被多次订阅,反复播放内容

- (void)rac_replayTest
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return nil;
        
    }] ;
    
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [subscriber sendNext:@1];
//        [subscriber sendNext:@2];
//        return nil;
//    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

//throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。

- (void)rac_throttleTest
{
    RACSubject *subject = [RACSubject subject];
    
    [[subject throttle:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendNext:@4];
    
}
#pragma mark --------- 我是分割线------------------

- (void)bindViewModel
{
    self.viewModel = [[LoginViewModel alloc]init];
    
    @weakify(self)
    RAC(self.viewModel, username) = self.userNameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    RAC(self.loginButton, enabled) = self.viewModel.validLoginSignal;
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.loginCommand execute:@"xxx"];
    }];
}

- (void)rac_netRequest
{
    self.fetchButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        [self.navigationController pushViewController:[NetDataTableViewController new] animated:YES];
        return [RACSignal empty];
    }];
}

- (void)rac_netRequest1
{
    [[[XXClient manager] rac_GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"completed");
    }];
}

@end
