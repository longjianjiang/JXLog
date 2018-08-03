//
//  JXFileLogger.m
//  JXLog
//
//  Created by longjianjiang on 2018/7/20.
//  Copyright © 2018年 Jiang. All rights reserved.
//

#import "JXFileLogger.h"
#import "JXLogMacro.h"

static unsigned long long const kJXDefaultLogFilesDiskQuota  = 10 * 1024 * 1024; // 10 MB

@interface JXFileLogger () {
    NSString *_logsDirectory;
    unsigned long long _logFilesDiskQuota;
    
    NSFileHandle *_logFileHandle;
}

@property (nonatomic, readwrite, copy) NSString *logsSavePath;

@end


@implementation JXFileLogger

#pragma mark - public method
- (void)logMessage:(NSString *)logMessage {
    if (logMessage.length) {
        NSData *logData = [logMessage dataUsingEncoding:NSUTF8StringEncoding];
        
        @synchronized (self) {
            [[self logFileHandle] writeData:logData];
            [self didEndLogMessage];
        }
        
    }
}

#pragma mark - life cycle
- (instancetype)initWithLogsDiretroy:(NSString *)logsDirectory {
    self = [super init];
    if (self) {
        _logFilesDiskQuota = kJXDefaultLogFilesDiskQuota;
        
        NSString *logFileDirectory = [logsDirectory stringByAppendingPathComponent:@"JXLog"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:logFileDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:logFileDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        _logsDirectory = logFileDirectory;
    }
    return self;
}

-(void)dealloc {
    [_logFileHandle synchronizeFile];
    [_logFileHandle closeFile];
}

#pragma mark - private method
- (void)createNewLogFile {
    
    NSString *logName = [self getNewLogFileName];
    _logsSavePath = [_logsDirectory stringByAppendingPathComponent:logName];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:_logsSavePath isDirectory:NULL] ) {
        [[NSFileManager defaultManager] createFileAtPath:_logsSavePath contents:nil attributes:nil];
    }
    
    [self deleteOldLogFile:logName];
}

- (void)deleteOldLogFile:(NSString *)currentFileName {
    NSArray *logNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_logsDirectory error:NULL];
    NSMutableArray *logNeedToDelete = [NSMutableArray array];
    
    for (NSString *logName in logNames) {
        if ([logName isEqualToString:currentFileName]) {
            continue;
        }
        [logNeedToDelete addObject:logName];
    }
    
    for (NSString *logName in logNeedToDelete) {
        NSString *filePath = [_logsDirectory stringByAppendingPathComponent:logName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }
}


- (void)didEndLogMessage {
    
    unsigned long long fileSize = [_logFileHandle offsetInFile];
    
    if (fileSize > _logFilesDiskQuota) {
        NSLog(@"JXFileLogger: current log file size surpass _logFilesDiskQuota, so need to roll");
        [self rollLogFile];
    }
}

- (void)rollLogFile {
    if (_logFileHandle == nil) {
        return;
    }
    
    [_logFileHandle synchronizeFile];
    [_logFileHandle closeFile];
    _logFileHandle = nil;
}

#pragma mark - getter and setter
- (NSFileHandle *)logFileHandle {
    if (_logFileHandle == nil) {
        
        [self createNewLogFile];
        
        _logFileHandle = [NSFileHandle fileHandleForWritingAtPath:_logsSavePath];;
        [_logFileHandle seekToEndOfFile];
    }
    
    return _logFileHandle;
}

- (NSString *)getNewLogFileName {
    NSString *appName = [self applicationName];
    
    NSDateFormatter *dateFormatter = [self formatter];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@-%@.log",appName, formattedDate];
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

- (NSString *)applicationName {
    static NSString *_appName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
        if (!_appName) {
            _appName = [[NSProcessInfo processInfo] processName];
        }
        if (!_appName) {
            _appName = @"";
        }
    });
    return _appName;
}
@end
