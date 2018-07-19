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


@end
