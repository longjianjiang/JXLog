//
//  JXConsoleLogger.m
//  JXLog
//
//  Created by zl on 2018/7/23.
//  Copyright © 2018年 Jiang. All rights reserved.
//

#import "JXConsoleLogger.h"
#import "JXFileLogger.h"

NSString * const JXLoggerDefaultDomain = @"JXLogger";

@interface JXConsoleLogger ()

@property (nonatomic, copy) NSString *domain;
@property (nonatomic, assign) JXLoggerLevel levelMask;

@property (nonatomic, strong) JXFileLogger *fileLoger;

@end


@implementation JXConsoleLogger

+ (void)load {
    [self addLoggerWithDomain:JXLoggerDefaultDomain];
    [[JXConsoleLogger logger] setLoggerLevelMask:JXLoggerLevelAll];
}

#pragma mark - class method
+ (id)loggerWithDomain:(NSString *)domain {
    return [self.loggers objectForKey:domain];
}

+ (instancetype)logger {
    return [self loggerWithDomain:JXLoggerDefaultDomain];
}

+ (void)addLoggerWithDomain:(NSString *)domain {
    JXConsoleLogger *logger = [self loggerWithDomain:domain];
    if (!logger) {
        logger = [JXConsoleLogger new];
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
    JXConsoleLogger *logger = [self loggerWithDomain:domain];
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

#pragma mark - init method
static dispatch_once_t onceToken;
static uint8_t dispatchSpecificKey = 0;
static uint8_t dispatchSpecificContext = 0;

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_once(&onceToken, ^{
            dispatch_queue_set_specific(dispatch_get_main_queue(), &dispatchSpecificKey, &dispatchSpecificContext, NULL);
        });
    }
    return self;
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
    
    if ([self hasFreeDiskSpace] == NO) {
        return;
    }

    if (dispatch_get_specific(&dispatchSpecificKey) == &dispatchSpecificContext) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.fileLoger logMessage:logContent];
        });
    } else {
        [self.fileLoger logMessage:logContent];
    }
}

- (BOOL)hasFreeDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) { return NO; }
    long long space = [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) { return NO; }
    if (space < self.fileLoger.logFilesDiskQuota) { return NO; }
    return YES;
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
