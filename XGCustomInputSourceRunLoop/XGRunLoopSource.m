//
//  XGRunLoopSource.m
//  XGCustomInputSourceRunLoop
//
//  Created by xxg90s on 2022/4/19.
//

#import "XGRunLoopSource.h"
#import "XGRunLoopContext.h"
#import "AppDelegate.h"

// 调度函数，可以让其他感兴趣的client知道如何与其交互（XGRunLoopContext）
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode) {
    XGRunLoopSource *obj = (__bridge XGRunLoopSource *)info;
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    XGRunLoopContext *theContext = [[XGRunLoopContext alloc] initWithSource:obj runLoop:rl];
    [del performSelectorOnMainThread:@selector(registerSource:)
                          withObject:theContext waitUntilDone:NO];
}

// 处理函数
void RunLoopSourcePerformRoutine (void *info) {
    XGRunLoopSource *obj = (__bridge XGRunLoopSource *)info;
    [obj sourceFired];
}

// 取消函数，使输入源XGRunLoopContext无效
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode) {
    XGRunLoopSource *obj = (__bridge XGRunLoopSource *)info;
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    XGRunLoopContext *theContext = [[XGRunLoopContext alloc] initWithSource:obj
                                                                      runLoop:rl];
    [del performSelectorOnMainThread:@selector(removeSource:)
                          withObject:theContext waitUntilDone:YES];
}

@implementation XGRunLoopSource

- (instancetype)init {
    if (self = [super init]) {
        /*
        RunLoopSourceScheduleRoutine():把当前的RunLoop Source添加到RunLoop中时，会回调这个方法。
         假如主线程管理该Input source，可以使用performSelectorOnMainThread通知主线程。主线程和当前线程的通信使用CCRunLoopContext对象来完成。
         RunLoopSourcePerformRoutine():当前Input source被告知需要处理事件
         RunLoopSourceCancelRoutine():如果使用CFRunLoopSourceInvalidate函数把输入源从RunLoop里面移除的话,系统会回调该方法。我们在该方法中移除了主线程对当前Input source context的引用。
                 */
        CFRunLoopSourceContext context = {0, (__bridge void *)self, NULL, NULL, NULL, NULL, NULL, &RunLoopSourceScheduleRoutine, RunLoopSourceCancelRoutine, RunLoopSourcePerformRoutine};
        _runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
        _commands = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addToCurrentRunLoop {
    NSLog(@"自定义事件添加到当前RunLoop");
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

- (void)invalidate {
    NSLog(@"自定义事件从当前RunLoop移除");
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopRemoveSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

- (void)sourceFired {
    NSLog(@"执行任务被触发");
    if ([self.delegate respondsToSelector:@selector(source:command:)]) {
        if ([_commands count] > 0) {
            NSInteger command = [_commands[0] integerValue];
            [self.delegate source:self command:command];
            [_commands removeLastObject];
        }
    }
}

- (void)addCommand:(NSInteger)command data:(nullable id)data {
    NSLog(@"添加命令%zd with data = %@", command, data);
    [_commands addObject:@(command)];
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop {
    NSLog(@"唤醒RunLoop执行命令");
    // 向source发出信号并让Runloop做相关的处理事务
    CFRunLoopSourceSignal(_runLoopSource);
    // 当信号到达时，线程有可能是处于休眠状态，所以我们需要来唤醒Runloop（达到唤醒线程的目的）。否则可能导致延迟处理输入源
    CFRunLoopWakeUp(runLoop);
}

@end
