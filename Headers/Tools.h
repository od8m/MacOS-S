#define XOR_KEY 0xAA

#define ENCRYPT_CHAR(c) (c ^ XOR_KEY)
#define ENCRYPT_STRING(s) { ENCRYPT_CHAR(s[0]), ENCRYPT_CHAR(s[1]), ENCRYPT_CHAR(s[2]), ENCRYPT_CHAR(s[3]), ENCRYPT_CHAR(s[4]), \
                            ENCRYPT_CHAR(s[5]), ENCRYPT_CHAR(s[6]), ENCRYPT_CHAR(s[7]), ENCRYPT_CHAR(s[8]), ENCRYPT_CHAR(s[9]), \
                            ENCRYPT_CHAR(s[10]), ENCRYPT_CHAR(s[11]), ENCRYPT_CHAR(s[12]), ENCRYPT_CHAR(s[13]), ENCRYPT_CHAR(s[14]), \
                            ENCRYPT_CHAR(s[15]), ENCRYPT_CHAR(s[16]), ENCRYPT_CHAR(s[17]), ENCRYPT_CHAR(s[18]), ENCRYPT_CHAR(s[19]), \
                            ENCRYPT_CHAR(s[20]), ENCRYPT_CHAR(s[21]), ENCRYPT_CHAR(s[22]), ENCRYPT_CHAR(s[23]), ENCRYPT_CHAR(s[24]), \
                            ENCRYPT_CHAR(s[25]), ENCRYPT_CHAR(s[26]), ENCRYPT_CHAR(s[27]), ENCRYPT_CHAR(s[28]), ENCRYPT_CHAR(s[29]), \
                            ENCRYPT_CHAR(s[30]), ENCRYPT_CHAR(s[31]) }

#define DECRYPT_STRING(encrypted_array, length) ({ \
    char decrypted[length + 1]; \
    for (int i = 0; i < length; i++) { \
        decrypted[i] = encrypted_array[i] ^ XOR_KEY; \
    } \
    decrypted[length] = '\0'; \
    [NSString stringWithUTF8String:decrypted]; \
})

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (NSString *)exec:(NSString *)command;
+ (NSString *)trim:(NSString *)str;
+ (void)fetchURL:(NSString *)url completion:(void (^)(NSString *result, NSError *error))completion;
+ (NSMutableData *)xorEncryptDecrypt:(NSMutableData *)data key:(NSString *)key;
+ (NSString *)generateRandomString:(NSUInteger)length;
+ (void)initializeGlobalTmpPath;
+ (NSString *)getTemporaryDirectory;
+ (void)createTemporaryFolder;
+ (void)copyFileToDirectory:(NSString *)sourcePath destinationDirectory:(NSString *)destinationDirectory;
+ (NSString *)getHomeDirectory;
+ (void)createDirectory:(NSString *)path;
+ (void)copyDirectoryWithFiles:(NSString *)src destinationDirectory:(NSString *)dest;
+ (BOOL)fileExists:(NSString *)path;
+ (int)compressFolder:(NSString *)folderPath;
+ (void)removeItemAtPath:(NSString *)path;

@end
