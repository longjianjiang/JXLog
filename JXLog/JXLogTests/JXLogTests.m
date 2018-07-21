//
//  JXLogTests.m
//  JXLogTests
//
//  Created by longjianjiang on 2018/7/19.
//  Copyright © 2018 Jiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JXLog.h"

@interface JXLogTests : XCTestCase

@end

@implementation JXLogTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLogLevel {
    JXLogDebug(@"👇 JXLog have five log level 👇");
    JXLogError(@"JXLoggerLevelError");
    JXLogWarning(@"JXLoggerLevelWarning");
    JXLogDebug(@"JXLoggerLevelDebug");
    JXLogInfo(@"JXLoggerLevelInfo");
    JXLogVerbose(@"JXLoggerLevelVerbose");
    JXLogDebug(@"👆---------------------------👆");
}

- (void)testLogEnable {
    JXLogDebug(@"测试 Log 控制");
    JXLogVerbose(@"测试 开关 控制，默认开启");
    for (int i = 0; i < 10; i++) {
        if (i == 5) [[JXLogger logger] setAllLogsEnable:NO];
        JXLogInfo(@"第 %d", i);
    }
    [[JXLogger logger] setAllLogsEnable:YES];
    JXLogError(@"可以看到上面的 Log 信息中只有前 5 个，后面因为打印开关关闭而停止了 log");
}

@end
