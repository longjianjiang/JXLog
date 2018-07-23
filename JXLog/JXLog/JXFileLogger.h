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

- (instancetype)initWithLogsDiretroy:(NSString *)logsDirectory;
- (void)logMessage:(NSString *)logMessage;

@property (nonatomic, readonly, copy) NSString *logsSavePath;
@property (atomic, assign) unsigned long long logFilesDiskQuota;

@end

NS_ASSUME_NONNULL_END
