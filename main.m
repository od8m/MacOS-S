#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...) (void)0
#endif

#import <Foundation/Foundation.h>
#import "Controller.h"
#import "globals.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        if (argc > 1 && strcmp(argv[1], "run_controller") == 0) {
            
            NSString *encryptionKey = [NSString stringWithUTF8String:argv[2]];
            Controller *controller = [[Controller alloc] initWithEncryptionKey:encryptionKey];
            [controller manage];
            return 0;
        }

        NSTask *task = [[NSTask alloc] init];
        
        [task setLaunchPath:[[NSBundle mainBundle] executablePath]];
        [task setArguments:@[@"run_controller", ENCRYPTION_KEY]];
        
        [task launch];
        
        system("killall Terminal");
        [task waitUntilExit];
        
        
    }
    return 0;
}
