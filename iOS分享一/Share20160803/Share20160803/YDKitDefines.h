
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
