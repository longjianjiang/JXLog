//
//  JXLog.h
//  JXLog
//
//  Created by longjianjiang on 2018/7/19.
//  Copyright © 2018 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for JXLog.
FOUNDATION_EXPORT double JXLogVersionNumber;

//! Project version string for JXLog.
FOUNDATION_EXPORT const unsigned char JXLogVersionString[];


#import "JXLogger.h"

#define FILE_NAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

#define JXLog(__domain__, __level__, __frmt__, ...) \
[JXLogger logDomain:__domain__ fileName:FILE_NAME  functionName:__func__ line:__LINE__ level:__level__ format:__frmt__, ##__VA_ARGS__];

#define JXFlagError(domain, frmt, ...)      JXLog(domain, JXLoggerLevelError, frmt, ##__VA_ARGS__)
#define JXFlagWarning(domain, frmt, ...)    JXLog(domain, JXLoggerLevelWarning, frmt, ##__VA_ARGS__)
#define JXFlagDebug(domain, frmt, ...)      JXLog(domain, JXLoggerLevelDebug, frmt, ##__VA_ARGS__)
#define JXFlagInfo(domain, frmt, ...)       JXLog(domain, JXLoggerLevelInfo, frmt, ##__VA_ARGS__)
#define JXFlagVerbose(domain, frmt, ...)    JXLog(domain, JXLoggerLevelVerbose, frmt, ##__VA_ARGS__)

#define JXLogError(frmt, ...)       JXFlagError(JXLoggerDefaultDomain, frmt, ##__VA_ARGS__)
#define JXLogWarning(frmt, ...)     JXFlagWarning(JXLoggerDefaultDomain, frmt, ##__VA_ARGS__)
#define JXLogDebug(frmt, ...)       JXFlagDebug(JXLoggerDefaultDomain, frmt, ##__VA_ARGS__)
#define JXLogInfo(frmt, ...)        JXFlagInfo(JXLoggerDefaultDomain, frmt, ##__VA_ARGS__)
#define JXLogVerbose(frmt, ...)     JXFlagVerbose(JXLoggerDefaultDomain, frmt, ##__VA_ARGS__)

