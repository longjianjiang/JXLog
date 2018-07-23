//
//  JXLogger.m
//  JXLog
//
//  Created by longjianjiang on 2018/7/19.
//  Copyright © 2018 Jiang. All rights reserved.
//

#import "JXLogger.h"
#import "JXFileLogger.h"

NSString * const JXLoggerDefaultDomain = @"JXLogger";

@interface JXLogger()

@property (nonatomic, copy) NSString *domain;
@property (nonatomic, assign) JXLoggerLevel levelMask;

@property (nonatomic, strong) JXFileLogger *fileLoger;

@end


@implementation JXLogger

+ (void)load {
    [self addLoggerWithDomain:JXLoggerDefaultDomain];
    [[JXLogger logger] setLoggerLevelMask:JXLoggerLevelAll];
}

#pragma mark - class method
+ (id)loggerWithDomain:(NSString *)domain {
    return [self.loggers objectForKey:domain];
}

+ (instancetype)logger {
    return [self loggerWithDomain:JXLoggerDefaultDomain];
}

+ (void)addLoggerWithDomain:(NSString *)domain {
    JXLogger *logger = [self loggerWithDomain:domain];
    if (!logger) {
        logger = [JXLogger new];
        logger.domain = domain;
        [logger setAllLogsEnable:YES];
        self.loggers[domain] = logger;
    }
}

+ (void)removeLoggerWithDomain:(NSString *)domain {
    if ([self.loggers objectForKey:domain]) {
        [self.loggers removeObjectForKey:domain];
    }
}

+ (void)logDomain:(NSString *)domain fileName:(const char *)fileName functionName:(const char *)functionName line:(const int)line level:(JXLoggerLevel)level format:(NSString *)format, ... {
    JXLogger *logger = [self loggerWithDomain:domain];
    if (!logger) return;
    if (!(level & logger.levelMask)) return;

    NSString *logContent;
    if (format) {
        va_list args;
        va_start(args, format);
        logContent = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }

    [logger logLevel:level file:fileName func:functionName line:line message:logContent];
}


#pragma mark - instance method
- (void)setLogSaveDirectory:(NSString *)directory logFilesDiskQuota:(long long)logFilesDiskQuota {
    self.fileLoger = [[JXFileLogger alloc] initWithLogsDiretroy:directory];
    
    if (logFilesDiskQuota > 0) {
        self.fileLoger.logFilesDiskQuota = logFilesDiskQuota;
    }
}

- (NSString *)getLogSavePath {
    return self.fileLoger.logsSavePath;
}

- (void)setAllLogsEnable:(BOOL)enable {
    [self setLoggerLevelMask:enable ? JXLoggerLevelAll : JXLoggerLevelOff];
}

- (void)setLoggerLevelMask:(JXLoggerLevel)mask {
    self.levelMask = mask;
}

#pragma mark - private method
- (void)logLevel:(JXLoggerLevel)level file:(const char *)file func:(const char *)func line:(const int)line message:(NSString *)message {
    NSString *prefix;
    switch (level) {
        case JXLoggerLevelError:
            prefix = @"❌";
            break;
        case JXLoggerLevelWarning:
            prefix = @"⚠️";
            break;
        default:
            prefix = @"💚";
            break;
    }
    
    if (!message) message = @"";
    
    NSString *logContent = [NSString stringWithFormat:@"%@ %@ <%@> %d %@  %@\n", [self.formatter stringFromDate:[NSDate date]], prefix, [NSString stringWithUTF8String:file], line, [NSString stringWithUTF8String:func], message];
    
    fprintf(stderr, "%s", logContent.UTF8String);
    
#ifdef DEBUG
#else
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.fileLoger logMessage:logContent];
    });
#endif
    
}

#pragma mark - getter and setter
+ (NSMutableDictionary *)loggers {
    static NSMutableDictionary *_loggers;
    if (!_loggers) {
        _loggers = @{}.mutableCopy;
    }
    return _loggers;
}

- (NSDateFormatter *)formatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSS";
    });
    return formatter;
}


@end
