//
//  JXFileLogger.m
//  JXLog
//
//  Created by longjianjiang on 2018/7/20.
//  Copyright © 2018年 Jiang. All rights reserved.
//

#import "JXFileLogger.h"

static unsigned long long const kJXDefaultLogFilesDiskQuota  = 10 * 1024 * 1024; // 10 MB


@interface JXFileLogger () {
    NSString *_logsDirectory;
    unsigned long long _logFilesDiskQuota;
    
    NSFileHandle *_logFileHandle;
}

@property (nonatomic, readwrite, copy) NSString *logsSavePath;

@end


@implementation JXFileLogger

- (instancetype)initWithLogsDiretroy:(NSString *)logsDirectory {
    self = [super init];
    if (self) {
        _logFilesDiskQuota = kJXDefaultLogFilesDiskQuota;
        _logsDirectory = logsDirectory;
         NSString *logName = [NSString stringWithFormat:@"%@.log", [self applicationName]];
        _logsSavePath = [logsDirectory stringByAppendingPathComponent:logName];
        
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:_logsSavePath isDirectory:NULL] ) {
            [[NSFileManager defaultManager] createFileAtPath:_logsSavePath contents:nil attributes:nil];
        }
        
    }
    return self;
}

-(void)dealloc {
    [_logFileHandle synchronizeFile];
    [_logFileHandle closeFile];
}

- (void)logMessage:(NSString *)logMessage {
    if (logMessage.length) {
        NSData *logData = [logMessage dataUsingEncoding:NSUTF8StringEncoding];
        
        @synchronized (self) {
            [[self logFileHandle] writeData:logData];
        }
        
    }
}


#pragma mark - getter and setter
- (NSFileHandle *)logFileHandle {
    if (_logFileHandle == nil) {
        _logFileHandle = [NSFileHandle fileHandleForWritingAtPath:_logsSavePath];;
        [_logFileHandle seekToFileOffset:0];
    }
    
    return _logFileHandle;
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
