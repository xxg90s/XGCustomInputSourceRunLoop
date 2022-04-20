//
//  XGRunLoopInpuSourceThread.m
//  XGCustomInputSourceRunLoop
//
//  Created by xxg90s on 2022/4/19.
//

#import "XGRunLoopInpuSourceThread.h"
#import "XGRunLoopSource.h"

@interface XGRunLoopInpuSourceThread ()<XGRunLoopSourceCallbackDelegate>

@property (nonatomic, strong) XGRunLoopSource *source;

@end

@implementation XGRunLoopInpuSourceThread

- (void)main {
    @autoreleasepool {
        NSLog(@"自定义线程进入");
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        //自定义事件源source0，通过代理触发子线程处理事件
        self.source = [[XGRunLoopSource alloc] init];
        self.source.delegate = self;
        [self.source addToCurrentRunLoop];
        while (!self.cancelled) {
            NSLog(@"进入RunLoop");
            [self doOtherTask];
            [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"退出RunLoop");
        }
        NSLog(@"自定义线程退出");
    }
}

- (void)doOtherTask {
    NSLog(@"模拟执行其他任务开始");
    NSLog(@"-------------------");
    NSLog(@"模拟执行其他任务结束");
}

#pragma mark - XGRunLoopSourceCallbackDelegate
- (void)source:(XGRunLoopSource *)source command:(NSInteger)command {
    NSLog(@"执行任务Source事件=%zd", command);
    NSLog(@"-------------------");
    NSLog(@"执行任务Source事件完成=%zd", command);
}

@end
