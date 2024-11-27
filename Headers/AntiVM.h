#import <Foundation/Foundation.h>

@interface AntiVM : NSObject

+ (BOOL)checkVM;
+ (BOOL)isDebuggerAttached;
+ (BOOL)isRussianLanguageInstalled;

@end

