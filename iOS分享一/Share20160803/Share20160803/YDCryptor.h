
#import <Foundation/Foundation.h>
#import "YDKitDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDCryptor : NSObject

/**
 *  Create a MD5 string
 *
 *  @param string The string to be converted
 *
 *  @return Returns the MD5 NSString
 */
+ (NSString * YD__NULLABLE)MD5:(NSString * )string;

@end

NS_ASSUME_NONNULL_END

//2. Lightweight Generics  轻量级泛型

//Lightweight Generics 是一个轻量级泛型，轻量是因为这是个纯编译器的语法支持（llvm 7.0），和 Nullability 一样，没有借助任何 objc runtime 的升级，也就是说，这个新语法在 Xcode 7 上可以使用且完全向下兼容（更低的iOS 版本）

//有了泛型后可以指定容器类中对象的类型：
//例如
//NSArray<NSString *> *strings = @[@"sun", @"yuan",];
//NSDictionary<NSString *, NSNumber *> *mapping = @{@"a": @1, @"b": @2};


//@property (readonly) NSArray *imageURLs;
//@property (readonly) NSArray<NSURL *> *imageURLs;

//优点
//1.提高程序员开发规范,一看就知道是什么类型
//2.限制类型,不允许传入其他的类型
//3.从集合中取出来,直接可以使用点语法


//3. id ,instancetype,__kindof

//id
//优点:可以调用任何对象方法
//缺点:不能使用点语法,不能做编译检查.

//instancetype: 表示某个方法返回的未知类型的Objective-C对象
//优点:会自动识别当前类的对象

//__kindof 修饰符  xcode7 表示当前类或者子类
//- (nullable __kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
//规定返回的是UITableViewCell这个类或者其子类
//比如说一个NSArray<UIView *>*,如果不加__kindof，这个数组只能有UIView,即便是其子类也不行。而加了的话，传入UIImageView或者UIButton之类的不会有问题。

//这些新特性以及如 instancetype 这样的历史更新，Objective-C 这门古老语言的类型检测和类型推断终于有所长进，现在不论是接口还是代码中的 id 类型都越来越少，更多潜在的类型错误可以被编译器的静态检查发现。
