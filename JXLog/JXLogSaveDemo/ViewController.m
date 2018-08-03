//
//  ViewController.m
//  JXLogSaveDemo
//
//  Created by zl on 2018/7/21.
//  Copyright © 2018年 Jiang. All rights reserved.
//

#import "ViewController.h"
#import "CTPersistanceAsyncExecutor.h"
#import <JXLog/JXLog.h>

#define COUNT 20

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[CTPersistanceAsyncExecutor sharedInstance] read:^{
        NSInteger count = COUNT;
        while (count --> 0) {
            JXLogError(@"read error %d", count);
        }
    }];

    NSInteger count = COUNT;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            JXLogWarning(@"read warning %d", count);
        }];
    }

    [[CTPersistanceAsyncExecutor sharedInstance] write:^{
        NSInteger count = COUNT;
        while (count --> 0) {
            JXLogDebug(@"write debug %d",count);
        }
    }];
    
//    NSMutableArray *arr = [NSMutableArray array];
//    [arr removeObjectAtIndex:0];
}


@end
