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

+ (instancetype)logger;

+ (id)loggerWithDomain:(NSString *)domain;
+ (void)addLoggerWithDomain:(NSString *)domain;
+ (void)removeLoggerWithDomain:(NSString *)domain;

- (void)setAllLogsEnable:(BOOL)enable;
- (void)setLoggerLevelMask:(JXLoggerLevel)mask;
- (void)setLogSavePath:(NSString *)path;

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
