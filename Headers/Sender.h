#import <Foundation/Foundation.h>

@interface Sender : NSObject

- (void)sendData;
- (void)postDataToC2Server:(NSString *)c2Address jsonData:(NSString *)jsonData completion:(void (^)(BOOL success, NSError *error))completion;

@end
