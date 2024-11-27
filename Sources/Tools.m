#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...) (void)0
#endif

#import "Tools.h"
#import <Foundation/Foundation.h>
#import "globals.h"


@implementation Tools

+ (NSString *)exec:(NSString *)command {
    NSTask *task = [[NSTask alloc] init];
    
    [task setLaunchPath:@"/bin/sh"];
    
    [task setArguments:@[@"-c", command]];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    
    [task launch];
    
    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
    
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return output;
}


+ (NSString *)trim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (void)fetchURL:(NSString *)url completion:(void (^)(NSString *result, NSError *error))completion {
    NSURL *nsurl = [NSURL URLWithString:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:nsurl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            DebugLog(@"Error fetching URL: %@", error.localizedDescription);
            if (completion) {
                completion(nil, error);
            }
        } else {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                completion(result, nil);
            }
        }
    }];
    [task resume];
}

+ (NSMutableData *)xorEncryptDecrypt:(NSMutableData *)data key:(NSString *)key {
    NSUInteger dataLength = [data length];
    NSUInteger keyLength = [key length];
    unsigned char *dataPtr = (unsigned char *)[data mutableBytes];
    const char *keyPtr = [key UTF8String];
    
    for (NSUInteger i = 0; i < dataLength; i++) {
        dataPtr[i] ^= keyPtr[i % keyLength];
    }
    
    return data;
}

+ (NSString *)generateRandomString:(NSUInteger)length {
    NSString *characters = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (NSUInteger i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [characters characterAtIndex:arc4random_uniform((uint32_t)[characters length])]];
    }
    
    return randomString;
}

+ (void)initializeGlobalTmpPath {
    TEMPORARY_PATH = [[self getTemporaryDirectory] stringByAppendingString:[self generateRandomString:25]];
    [self createTemporaryFolder];
}

+ (NSString *)getTemporaryDirectory {
    NSString *tmpDir = [NSString stringWithUTF8String:getenv("TMPDIR")];
    if (!tmpDir) {
        tmpDir = @"/tmp/";
    }
    return tmpDir;
}

+ (void)createTemporaryFolder {
    if (![[NSFileManager defaultManager] fileExistsAtPath:TEMPORARY_PATH]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:TEMPORARY_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)copyFileToDirectory:(NSString *)sourcePath destinationDirectory:(NSString *)destinationDirectory {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:destinationDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        DebugLog(@"Error creating directory: %@", error.localizedDescription);
        return;
    }
    
    NSString *destinationPath = [destinationDirectory stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    if (error) {
        DebugLog(@"Error copying file: %@", error.localizedDescription);
    }
}

+ (NSString *)getHomeDirectory {
    return NSHomeDirectory();
}

+ (void)createDirectory:(NSString *)path {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        DebugLog(@"Error creating directory: %@", error.localizedDescription);
    }
}

+ (void)copyDirectoryWithFiles:(NSString *)src destinationDirectory:(NSString *)dest {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if (![fileManager fileExistsAtPath:src]) {
        DebugLog(@"Source directory does not exist or is not a directory.");
        return;
    }
    
    if (![fileManager fileExistsAtPath:dest]) {
        [fileManager createDirectoryAtPath:dest withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DebugLog(@"Error creating destination directory: %@", error.localizedDescription);
            return;
        }
    }
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:src error:&error];
    if (error) {
        DebugLog(@"Error reading source directory contents: %@", error.localizedDescription);
        return;
    }
    
    for (NSString *entry in contents) {
        NSString *srcPath = [src stringByAppendingPathComponent:entry];
        NSString *destPath = [dest stringByAppendingPathComponent:entry];
        
        BOOL isDirectory = NO;
        [fileManager fileExistsAtPath:srcPath isDirectory:&isDirectory];
        
        if (isDirectory) {
            [self copyDirectoryWithFiles:srcPath destinationDirectory:destPath];
        } else {
            [fileManager copyItemAtPath:srcPath toPath:destPath error:&error];
            if (error) {
                DebugLog(@"Error copying file %@ to %@: %@", srcPath, destPath, error.localizedDescription);
            }
        }
    }
}

+ (BOOL)fileExists:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (int)compressFolder:(NSString *)folderPath {
    NSString *command = [NSString stringWithFormat:@"ditto -c -k %@ %@.zip --norsrc --noextattr", folderPath, folderPath];
    return system([command UTF8String]);
}

+ (void)removeItemAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    
    if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        NSError *error = nil;
        
        if (isDirectory) {
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:&error];
            
            if (error) {
                NSLog(@"Error retrieving directory contents: %@", [error localizedDescription]);
                return;
            }
            
            for (NSString *item in contents) {
                NSString *fullPath = [path stringByAppendingPathComponent:item];
                
                if (![fileManager removeItemAtPath:fullPath error:&error]) {
                    NSLog(@"Error removing item: %@", [error localizedDescription]);
                }
            }
            
            if (![fileManager removeItemAtPath:path error:&error]) {
                NSLog(@"Error removing directory: %@", [error localizedDescription]);
            }
        } else {
            if (![fileManager removeItemAtPath:path error:&error]) {
                NSLog(@"Error removing file: %@", [error localizedDescription]);
            }
        }
    } else {
        NSLog(@"Path does not exist: %@", path);
    }
}

@end
