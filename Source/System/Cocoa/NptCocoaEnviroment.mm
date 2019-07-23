/*****************************************************************
|
|      Neptune - System Support: Cocoa Implementation
|
|      (c) 2002-2006 Gilles Boccon-Gibod
|      Author: Sylvain Rebaud (sylvain@rebaud.com)
|
****************************************************************/

/*----------------------------------------------------------------------
|       includes
+---------------------------------------------------------------------*/
#include "NptConfig.h"
#include "NptSystem.h"

#include <TargetConditionals.h>
#import <Foundation/Foundation.h>

#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#elif TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#else
#import <SystemConfiguration/SystemConfiguration.h>
#endif

NPT_Result
NPT_GetSystemMachineName(NPT_String& name)
{
    // we need a pool because of UTF8String
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

#if TARGET_OS_WATCH
    name = [[[WKInterfaceDevice currentDevice] name] UTF8String];
#elif TARGET_OS_IOS || TARGET_OS_TV
    name = [[[UIDevice currentDevice] name] UTF8String];
#else
    CFStringRef _name = SCDynamicStoreCopyComputerName(NULL, NULL);
    name = [(NSString *)_name UTF8String];
    [(NSString *)_name release];
#endif
    
    [pool release];
    return NPT_SUCCESS;
}
