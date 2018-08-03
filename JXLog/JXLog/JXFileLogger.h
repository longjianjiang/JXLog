//
//  JXFileLogger.h
//  JXLog
//
//  Created by longjianjiang on 2018/7/20.
//  Copyright © 2018年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXFileLogger : NSObject

/**
 will create `JXLog` directory at `logsDirectory` and save log file at `JXLog` directory
 */
- (instancetype)initWithLogsDiretroy:(NSString *)logsDirectory;

/**
 save a message to log file
 */
- (void)logMessage:(NSString *)logMessage;

/**
 get current log file path
 */
@property (nonatomic, readonly, copy) NSString *logsSavePath;

/**
 set log file max size, if exceed this number will roll and create a new log file
 */
@property (atomic, assign) unsigned long long logFilesDiskQuota;

@end

NS_ASSUME_NONNULL_END
