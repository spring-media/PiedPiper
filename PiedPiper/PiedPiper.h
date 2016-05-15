//
//  PiedPiper.h
//  PiedPiper
//
//  Created by Vittorio Monaco on 15/05/16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

#ifdef __APPLE__
#include "TargetConditionals.h"
#if TARGET_OS_IPHONE
// iOS
#import <UIKit/UIKit.h>
#elif TARGET_IPHONE_SIMULATOR
// iOS Simulator
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
// Other kinds of Mac OS
#include <Cocoa/Cocoa.h>
#else
// Unsupported platform
#endif
#endif

//! Project version number for PiedPiper.
FOUNDATION_EXPORT double PiedPiperVersionNumber;

//! Project version string for PiedPiper.
FOUNDATION_EXPORT const unsigned char PiedPiperVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PiedPiper/PublicHeader.h>


