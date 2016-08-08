
#import <Foundation/Foundation.h>

#pragma mark - Objective-C Nullability Support

#if __has_feature(nullability)
#define YD_NONNULL nonnull
#define YD_NULLABLE nullable
#define YD_NULL_RESETTABLE null_resettable
#if USING_XCODE_7
#define YD__NONNULL  _Nonnull   
#define YD__NULLABLE _Nullable
#define YD__NULL_RESETTABLE _Null_resettable
#else
#define YD__NONNULL __nonnull
#define YD__NULLABLE __nullable
#define YD__NULL_RESETTABLE __null_resettable
#endif
#else
#define YD_NONNULL
#define YD__NONNULL
#define YD_NULLABLE
#define YD__NULLABLE
#define YD_NULL_RESETTABLE
#define YD__NULL_RESETTABLE
#endif

//1. Nullability 特性 (swift ？ !)

//我们都知道在swift中，可以使用!和?来表示一个对象是optional的还是non-optional，如view?和view!。而在Objective-C中则没有这一区分，view即可表示这个对象是optional，也可表示是non-optioanl。这样就会造成一个问题：在Swift与Objective-C混编时，Swift编译器并不知道一个Objective-C对象到底是optional还是non-optional，因此这种情况下编译器会隐式地将Objective-C的对象当成是non-optional。为了解决这个问题，苹果在Xcode 6.3引入了一个Objective-C的新特性：nullability annotations。

//1.方式一:(策略)
//@property (nonatomic, strong, nullable) NSString *name;
//
//2.方式二:_Nullable(*后面,变量名前面)
//@property (nonatomic, strong) NSString * _Nullable name;
//
//3.方式三:__nullable(*后面,变量名前面),xcode7beta(测试版本)
//@property (nonatomic, strong) NSString * __nullable name;

//
//1.方式一:(策略)
//@property (nonatomic, strong, nonnull) NSString *name;
//
//2.方式二:_Nullable(*后面,变量名前面)
//@property (nonatomic, strong) NSString * _Nonnull name;
//
//3.方式三:__nullable(*后面,变量名前面),xcode7beta(测试版本),beta创建的项目不能上传到App Store
//@property (nonatomic, strong) NSString * __nonnull name;


//nonnull 不允许为空
//
//nullable 允许为空
//
//null_resettable 来表示 setter nullable，但是 getter nonnull，

//事实上，在任何可以使用const关键字的地方都可以使用__nullable和__nonnull，不过这两个关键字仅限于使用在指针类型上。而在方法的声明中，我们还可以使用不带下划线的nullable和nonnull，如下所示：

//如果需要每个属性或每个方法都去指定nonnull和nullable,是一件非常繁琐的事,为了防止写一大堆 nonnull,Foundation 还提供了一对宏，NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END.包在里面的对象默认加 nonnull 修饰符，只需要把 nullable 的指出来就行

//这个功能最早被发布在Xcode 6.3上，关键字是__nullable和__nonnull，由于一些三方库潜在的冲突，
//在 Xcode 7上将关键字改为这里提到的_Nullable和_Nonnull，为了兼容Xcode 6.3，苹果定义了
//__nullable和__nonnull

//Nullability 在编译器层面提供了空值的类型检查，在类型不符时给出 warning，方便开发者第一时间发现潜在问题。


