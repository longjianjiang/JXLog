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

- (void)testDomainLog {
    NSString *domain = @"JXTestDomain";
    [JXLogger addLoggerWithDomain:domain];
    JXFlagError(domain, @"这是一个高级用法，可以控制是否打印方法，并且需要绑定一个 domain");
    JXFlagWarning(domain, @"如果 domain 没有绑定，那么使用该 domain 的 Log 信息是不会输出的");
    JXFlagDebug(domain, @"目前的 domain 是: %@", domain);
    JXFlagInfo(domain, @"下面会用一个没有注册的 domain 来测试打印 --> JXFlagVerbose(YES, @\"OtherDomain\", @\"看不到我看不到我看不到我\");");
    JXFlagVerbose(@"OtherDomain", @"看不到我看不到我看不到我");
    JXFlagInfo(domain, @"看行号，发现少了一行，因为上一个没有注册 domain 没有打印");
}
@end
