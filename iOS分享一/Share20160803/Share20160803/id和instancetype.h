//1. 什么是instancetype
//instancetype是clang 3.5(Clang是一个C、C++、OC语言的轻量级编译器)开始,clang提供的一个关键字，表示某个方法返回的未知类型的Objective-C对象。我们都知道未知类型的的对象可以用id关键字表示，那为什么还会再有一个instancetype呢？

//2. 关联返回类型（related result types）

//根据Cocoa的命名规则，满足下述规则的方法：

//1、类方法中，以alloc或new开头

//2、实例方法中，以autorelease，init，retain或self开头

//会返回一个方法所在类类型的对象，这些方法就被称为是关联返回类型的方法

//@interface NSObject
//+ (id)alloc;
//- (id)init;
//@end@interface NSObject
//@interface NSArray : NSObject
//@end


//[[NSArray alloc]init] ---> NSArray*

//3. instancetype作用

//@interface NSArray
//+ (id)constructAnArray;  //根据Cocoa的方法命名规范，得到的返回类型就和方法声明的返回类型一样，是id。
//@end

//@interface NSArray
//+ (instancetype)constructAnArray;//得到的返回类型和方法所在类的类型相同，是NSArray*!
//@end

//总结一下，instancetype的作用，就是使那些非关联返回类型的方法返回所在类的类型！


//4、instancetype和id的异同
//
//1、相同点
//都可以作为方法的返回类型

//2、不同点
//①instancetype可以返回和方法所在类相同类型的对象，id只能返回未知类型的对象；
//
//②instancetype只能作为返回值，不能像id那样作为参数
