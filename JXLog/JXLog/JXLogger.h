//
//  JXLogger.h
//  JXLog
//
//  Created by longjianjiang on 2018/7/19.
//  Copyright © 2018 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const JXLoggerDefaultDomain;

typedef NS_ENUM(NSUInteger, JXLoggerLevel) {
    JXLoggerLevelOff        = 0,
    JXLoggerLevelError      = 1,        // ❌
    JXLoggerLevelWarning    = 1 << 1,   // ⚠️
    JXLoggerLevelDebug      = 1 << 2,
    JXLoggerLevelInfo       = 1 << 3,
    JXLoggerLevelVerbose    = 1 << 4,
    JXLoggerLevelAll        = NSUIntegerMax
};

@interface JXLogger : NSObject

/**
 get a default domain logger and it's log level is JXLoggerLevelAll
 */
+ (instancetype)logger;

/**
 get a logger with specified  domain
 */
+ (id)loggerWithDomain:(NSString *)domain;

/**
 add a logger with a specified domain
 */
+ (void)addLoggerWithDomain:(NSString *)domain;

/**
 remove a logger with a specified domain
 */
+ (void)removeLoggerWithDomain:(NSString *)domain;

/**
 set log level

 @param enable if YES then log level is JXLoggerLevelAll, otherwise log level is JXLoggerLevelOff
 */
- (void)setAllLogsEnable:(BOOL)enable;

/**
 set log level mask, use | operator combine multipe log level
 */
- (void)setLoggerLevelMask:(JXLoggerLevel)mask;

/**
 save log message as a .log file to sandbox

 @param directory save .log file directory
 */
- (void)setLogSaveDirectory:(NSString *)directory;

/**
 get .log file path
 */
- (NSString *)getLogSavePath;


/**
 log method

 @param domain logger domain
 @param fileName __FILE__
 @param functionName __func__
 @param line __LINE__
 @param level JXLoggerLevel
 @param format log message
 */
+ (void)logDomain:(NSString *)domain fileName:(const char *)fileName functionName:(const char *)functionName line:(const int)line level:(JXLoggerLevel)level format:(NSString *)format, ...;
@end
